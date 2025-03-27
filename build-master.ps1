# Advanced PowerShell build master for Tabby with evolution capabilities
# This script orchestrates all build processes and learns from previous builds

param (
    [Parameter(Position=0)]
    [ValidateSet("all", "release", "debug", "cuda", "rocm", "meta", "evolve", "auto", "")]
    [string]$Target = "auto",
    
    [switch]$Clean,
    [switch]$NoParallel,
    [switch]$NoDeps,
    [switch]$Run,
    [switch]$Learn,
    [switch]$Quiet,
    [int]$ParallelJobs = 0,
    [switch]$Schedule,
    [string]$ScheduleTime,
    [string]$BuildProfile,
    [switch]$SaveProfile
)

#region Initialization

$ErrorActionPreference = "Stop"
$startTime = Get-Date
$scriptPath = $PSScriptRoot
$buildHistoryPath = Join-Path $scriptPath "logs\build_history.json"
$buildProfilesPath = Join-Path $scriptPath "configs\build_profiles.json"

# Create directories if they don't exist
if (-not (Test-Path "logs")) { New-Item -ItemType Directory -Path "logs" | Out-Null }
if (-not (Test-Path "configs")) { New-Item -ItemType Directory -Path "configs" | Out-Null }

# Initialize build history if it doesn't exist
if (-not (Test-Path $buildHistoryPath)) {
    @{
        "builds" = @()
        "metrics" = @{
            "averageBuildTime" = @{}
            "successRate" = @{}
            "optimalParallelism" = $null
            "lastEvolution" = (Get-Date).ToString("o")
        }
    } | ConvertTo-Json -Depth 10 | Set-Content $buildHistoryPath
}

# Initialize build profiles if they don't exist
if (-not (Test-Path $buildProfilesPath)) {
    @{
        "profiles" = @{
            "default" = @{
                "parallelJobs" = 0
                "preferredGenerator" = "Ninja"
                "cmakeFlags" = @()
                "cargoFlags" = @()
                "evolution" = @{
                    "generation" = 1
                    "fitness" = 0
                }
            }
        }
    } | ConvertTo-Json -Depth 10 | Set-Content $buildProfilesPath
}

# Load build history
$buildHistory = Get-Content $buildHistoryPath | ConvertFrom-Json

# Load build profiles
$buildProfiles = Get-Content $buildProfilesPath | ConvertFrom-Json

# Determine build profile to use
if (-not $BuildProfile) {
    $BuildProfile = "default"
}

# If profile doesn't exist, create it
if (-not $buildProfiles.profiles.$BuildProfile) {
    $buildProfiles.profiles.$BuildProfile = @{
        "parallelJobs" = 0
        "preferredGenerator" = "Ninja"
        "cmakeFlags" = @()
        "cargoFlags" = @()
        "evolution" = @{
            "generation" = 1
            "fitness" = 0
        }
    }
    $buildProfiles | ConvertTo-Json -Depth 10 | Set-Content $buildProfilesPath
}

# Apply profile settings
$profile = $buildProfiles.profiles.$BuildProfile
if ($ParallelJobs -eq 0) {
    if ($profile.parallelJobs -gt 0) {
        $ParallelJobs = $profile.parallelJobs
    } else {
        # Auto-determine parallel jobs
        $logicalCores = [Environment]::ProcessorCount
        $physicalCores = (Get-CimInstance -ClassName Win32_Processor).NumberOfCores
        if (-not $physicalCores) { $physicalCores = $logicalCores }
        $ParallelJobs = [Math]::Min($logicalCores, $physicalCores * 2)
    }
}

#endregion

#region Functions

function Write-ColoredText {
    param (
        [string]$Text,
        [string]$Color = "White"
    )
    
    if (-not $Quiet) {
        Write-Host $Text -ForegroundColor $Color
    }
}

function Show-Header {
    if ($Quiet) { return }
    
    $banner = @"
╔═══════════════════════════════════════════════════════╗
║       TABBY MASTER BUILDER WITH AUTO-EVOLUTION        ║
╚═══════════════════════════════════════════════════════╝
"@
    Write-Host $banner -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Build Target: $Target" -ForegroundColor Yellow
    Write-Host "Profile: $BuildProfile" -ForegroundColor Yellow
    Write-Host "Parallel Jobs: $ParallelJobs" -ForegroundColor Yellow
    Write-Host "Build Time: $(Get-Date)" -ForegroundColor Yellow
    Write-Host ""
}

function Initialize-BuildEnvironment {
    # Add Rust to PATH if it exists
    if (Test-Path -Path "$env:USERPROFILE\.cargo\bin") {
        $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
    }

    # Add Python Ninja to PATH if it exists
    $pythonNinjaPath = "$env:USERPROFILE\AppData\Roaming\Python\Python313\Scripts"
    if (Test-Path -Path "$pythonNinjaPath\ninja.exe") {
        $env:PATH = "$pythonNinjaPath;$env:PATH"
    }

    # Check for required tools
    if (-not $NoDeps) {
        $checkTools = & "$scriptPath\scripts\verify_tools.ps1" -Quiet
        
        if ($LASTEXITCODE -ne 0) {
            Write-ColoredText "Installing required build tools..." "Yellow"
            & "$scriptPath\scripts\install-ninja.ps1" -Quiet
            & "$scriptPath\scripts\install-cmake.ps1" -Quiet
        }
    }
}

function Start-AutoEvolution {
    Write-ColoredText "Starting build system evolution..." "Magenta"
    
    # Analyze build history to improve build process
    $history = $buildHistory.builds | Where-Object { $_.status -eq "success" }
    if ($history.Count -lt 3) {
        Write-ColoredText "Not enough successful builds to evolve. Run more builds first." "Yellow"
        return
    }
    
    # Calculate optimal parallel jobs based on history
    $targetBuild = $history | Where-Object { $_.target -eq $Target } | Sort-Object -Property duration
    if ($targetBuild.Count -gt 3) {
        $fastestBuilds = $targetBuild | Select-Object -First 3
        $optimalJobs = [Math]::Round(($fastestBuilds.parallelJobs | Measure-Object -Average).Average)
        
        # Update profile
        $profile.parallelJobs = $optimalJobs
        $profile.evolution.generation++
        $profile.evolution.fitness = ($targetBuild | Sort-Object -Property duration | Select-Object -First 1).duration
        
        # Save improved profile
        $buildProfiles | ConvertTo-Json -Depth 10 | Set-Content $buildProfilesPath
        
        Write-ColoredText "Evolution complete! Profile generation $($profile.evolution.generation)" "Green"
        Write-ColoredText "Optimal parallel jobs for $Target: $optimalJobs" "Green"
    } else {
        Write-ColoredText "Not enough data for $Target builds to evolve." "Yellow"
    }
}

function Record-BuildMetrics {
    param(
        [string]$Target,
        [string]$Status,
        [double]$Duration,
        [int]$ParallelJobs,
        [string]$ErrorMessage = ""
    )
    
    # Add build record to history
    $buildRecord = @{
        "id" = [guid]::NewGuid().ToString()
        "timestamp" = (Get-Date).ToString("o")
        "target" = $Target
        "status" = $Status
        "duration" = $Duration
        "parallelJobs" = $ParallelJobs
        "errorMessage" = $ErrorMessage
    }
    
    $buildHistory.builds += $buildRecord
    
    # Update metrics
    if (-not $buildHistory.metrics.averageBuildTime.$Target) {
        $buildHistory.metrics.averageBuildTime | Add-Member -MemberType NoteProperty -Name $Target -Value $Duration
    } else {
        # Weighted average (more weight to recent builds)
        $oldAvg = $buildHistory.metrics.averageBuildTime.$Target
        $buildHistory.metrics.averageBuildTime.$Target = ($oldAvg * 0.7) + ($Duration * 0.3)
    }
    
    # Calculate success rate
    $targetBuilds = @($buildHistory.builds | Where-Object { $_.target -eq $Target })
    $successBuilds = @($targetBuilds | Where-Object { $_.status -eq "success" })
    
    if (-not $buildHistory.metrics.successRate.$Target) {
        $buildHistory.metrics.successRate | Add-Member -MemberType NoteProperty -Name $Target -Value 0
    }
    
    if ($targetBuilds.Count -gt 0) {
        $buildHistory.metrics.successRate.$Target = [Math]::Round(($successBuilds.Count / $targetBuilds.Count) * 100, 2)
    }
    
    # Save build history
    $buildHistory | ConvertTo-Json -Depth 10 | Set-Content $buildHistoryPath
    
    if ($Learn -or $SaveProfile) {
        # Update profile with this build's settings if successful
        if ($Status -eq "success") {
            $profile.parallelJobs = $ParallelJobs
            $buildProfiles | ConvertTo-Json -Depth 10 | Set-Content $buildProfilesPath
        }
    }
}

function Invoke-Build {
    param(
        [string]$Target
    )
    
    $buildStartTime = Get-Date
    try {
        switch ($Target) {
            "release" { 
                Write-ColoredText "Building release version..." "Green"
                Build-Release 
            }
            "debug" { 
                Write-ColoredText "Building debug version..." "Blue"
                Build-Debug 
            }
            "cuda" { 
                Write-ColoredText "Building CUDA version..." "Magenta" 
                Build-Cuda 
            }
            "rocm" { 
                Write-ColoredText "Building ROCm version..." "Yellow" 
                Build-ROCm 
            }
            "all" { 
                Write-ColoredText "Building all configurations..." "Cyan"
                if (-not $NoParallel) {
                    Build-AllParallel
                } else {
                    Build-AllSequential
                }
            }
            "auto" {
                Write-ColoredText "Auto-detecting best build configuration..." "Cyan"
                
                # Check if NVIDIA GPU exists
                $hasNvidiaGpu = $false
                try {
                    $gpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "NVIDIA" }
                    $hasNvidiaGpu = ($gpu -ne $null)
                } catch {}
                
                # Check if AMD GPU exists
                $hasAmdGpu = $false
                try {
                    $gpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "AMD|Radeon" }
                    $hasAmdGpu = ($gpu -ne $null)
                } catch {}
                
                if ($hasNvidiaGpu) {
                    Write-ColoredText "NVIDIA GPU detected. Building CUDA version..." "Magenta"
                    Build-Cuda
                } elseif ($hasAmdGpu) {
                    Write-ColoredText "AMD GPU detected. Building ROCm version..." "Yellow"
                    Build-ROCm
                } else {
                    Write-ColoredText "No GPU detected or unsupported GPU. Building standard release..." "Green"
                    Build-Release
                }
            }
            "evolve" {
                Start-AutoEvolution
                return 0
            }
            default {
                Write-ColoredText "Unknown build target: $Target" "Red"
                return 1
            }
        }
        
        $buildEndTime = Get-Date
        $buildDuration = ($buildEndTime - $buildStartTime).TotalSeconds
        
        Write-ColoredText "Build completed in $([Math]::Round($buildDuration, 2)) seconds" "Green"
        Record-BuildMetrics -Target $Target -Status "success" -Duration $buildDuration -ParallelJobs $ParallelJobs
        
        # Run after build if requested
        if ($Run) {
            Start-TabbyAfterBuild -Target $Target
        }
        
        return 0
    } catch {
        $buildEndTime = Get-Date
        $buildDuration = ($buildEndTime - $buildStartTime).TotalSeconds
        
        Write-ColoredText "Build failed after $([Math]::Round($buildDuration, 2)) seconds: $_" "Red"
        Record-BuildMetrics -Target $Target -Status "failed" -Duration $buildDuration -ParallelJobs $ParallelJobs -ErrorMessage $_.Exception.Message
        
        return 1
    }
}

function Build-Release {
    if ($Clean) { Remove-BuildArtifacts -Target "release" }
    
    # Create build directory
    $buildDir = "build\cmake-Release"
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    
    # Run the build
    Push-Location $buildDir
    & cmake ..\.. -G $profile.preferredGenerator -DCMAKE_BUILD_TYPE=Release
    & cmake --build . -- -j$ParallelJobs
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    if ($exitCode -ne 0) {
        throw "Release build failed with exit code $exitCode"
    }
}

function Build-Debug {
    if ($Clean) { Remove-BuildArtifacts -Target "debug" }
    
    # Create build directory
    $buildDir = "build\cmake-Debug"
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    
    # Run the build
    Push-Location $buildDir
    & cmake ..\.. -G $profile.preferredGenerator -DCMAKE_BUILD_TYPE=Debug
    & cmake --build . -- -j$ParallelJobs
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    if ($exitCode -ne 0) {
        throw "Debug build failed with exit code $exitCode"
    }
}

function Build-Cuda {
    if ($Clean) { Remove-BuildArtifacts -Target "cuda" }
    
    # Create build directory
    $buildDir = "build\cmake-CUDA"
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    
    # Run the build
    Push-Location $buildDir
    & cmake ..\.. -G $profile.preferredGenerator -DCMAKE_BUILD_TYPE=Release -DTABBY_USE_CUDA=ON
    & cmake --build . -- -j$ParallelJobs
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    if ($exitCode -ne 0) {
        throw "CUDA build failed with exit code $exitCode"
    }
}

function Build-ROCm {
    if ($Clean) { Remove-BuildArtifacts -Target "rocm" }
    
    # Create build directory
    $buildDir = "build\cmake-ROCm"
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    
    # Run the build
    Push-Location $buildDir
    & cmake ..\.. -G $profile.preferredGenerator -DCMAKE_BUILD_TYPE=Release -DTABBY_USE_ROCM=ON
    & cmake --build . -- -j$ParallelJobs
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    if ($exitCode -ne 0) {
        throw "ROCm build failed with exit code $exitCode"
    }
}

function Build-AllParallel {
    if ($Clean) { Remove-BuildArtifacts -Target "all" }
    
    $jobs = @()
    
    # Start jobs for each build type
    $jobs += Start-Job -ScriptBlock {
        Set-Location $using:scriptPath
        
        # Create build directory
        $buildDir = "build\cmake-Release"
        New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
        
        # Run the build
        Set-Location $buildDir
        & cmake ..\.. -G $using:profile.preferredGenerator -DCMAKE_BUILD_TYPE=Release
        & cmake --build . -- -j$using:ParallelJobs
        return $LASTEXITCODE
    } -Name "ReleaseBuild"
    
    $jobs += Start-Job -ScriptBlock {
        Set-Location $using:scriptPath
        
        # Create build directory
        $buildDir = "build\cmake-Debug"
        New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
        
        # Run the build
        Set-Location $buildDir
        & cmake ..\.. -G $using:profile.preferredGenerator -DCMAKE_BUILD_TYPE=Debug
        & cmake --build . -- -j$using:ParallelJobs
        return $LASTEXITCODE
    } -Name "DebugBuild"
    
    $jobs += Start-Job -ScriptBlock {
        Set-Location $using:scriptPath
        
        # Create build directory
        $buildDir = "build\cmake-CUDA"
        New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
        
        # Run the build
        Set-Location $buildDir
        & cmake ..\.. -G $using:profile.preferredGenerator -DCMAKE_BUILD_TYPE=Release -DTABBY_USE_CUDA=ON
        & cmake --build . -- -j$using:ParallelJobs
        return $LASTEXITCODE
    } -Name "CudaBuild"
    
    # Wait for all jobs to complete and report results
    $jobs | ForEach-Object {
        $jobName = $_.Name
        Write-ColoredText "Waiting for $jobName to complete..." "Yellow"
        $_ | Wait-Job | Out-Null
        
        $result = Receive-Job $_
        if ($result -ne 0) {
            throw "$jobName failed with exit code $result"
        }
        
        Write-ColoredText "$jobName completed successfully" "Green"
    }
}

function Build-AllSequential {
    if ($Clean) { Remove-BuildArtifacts -Target "all" }
    
    # Build each configuration sequentially
    Build-Release
    Build-Debug
    Build-Cuda
}

function Remove-BuildArtifacts {
    param (
        [string]$Target
    )
    
    Write-ColoredText "Cleaning build artifacts for target: $Target" "Yellow"
    
    switch ($Target) {
        "release" {
            if (Test-Path "build\cmake-Release") {
                Remove-Item -Path "build\cmake-Release" -Recurse -Force
            }
        }
        "debug" {
            if (Test-Path "build\cmake-Debug") {
                Remove-Item -Path "build\cmake-Debug" -Recurse -Force
            }
        }
        "cuda" {
            if (Test-Path "build\cmake-CUDA") {
                Remove-Item -Path "build\cmake-CUDA" -Recurse -Force
            }
        }
        "rocm" {
            if (Test-Path "build\cmake-ROCm") {
                Remove-Item -Path "build\cmake-ROCm" -Recurse -Force
            }
        }
        "all" {
            if (Test-Path "build\cmake-*") {
                Remove-Item -Path "build\cmake-*" -Recurse -Force
            }
            if (Test-Path "target") {
                Remove-Item -Path "target" -Recurse -Force
            }
        }
    }
}

function Start-TabbyAfterBuild {
    param (
        [string]$Target
    )
    
    Write-ColoredText "Starting Tabby after build..." "Cyan"
    
    switch ($Target) {
        "cuda" {
            & "$scriptPath\run-tabby.bat" cuda
        }
        "rocm" {
            & "$scriptPath\run-tabby.bat" rocm
        }
        default {
            & "$scriptPath\run-tabby.bat" cpu
        }
    }
}

function Schedule-Build {
    param (
        [string]$Time
    )
    
    if (-not $Time) {
        $Time = "03:00" # Default to 3AM
    }
    
    $arguments = "-Target $Target"
    if ($Clean) { $arguments += " -Clean" }
    if ($NoParallel) { $arguments += " -NoParallel" }
    if ($NoDeps) { $arguments += " -NoDeps" }
    if ($BuildProfile) { $arguments += " -BuildProfile `"$BuildProfile`"" }
    
    Write-ColoredText "Scheduling build to run daily at $Time" "Cyan"
    
    $taskName = "TabbyBuilder_$Target"
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath\build-master.ps1`" $arguments -Quiet"
    $trigger = New-ScheduledTaskTrigger -Daily -At $Time
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -WakeToRun
    
    # Remove existing task if it exists
    Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
    
    # Create the new scheduled task
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description "Tabby Automated Build: $Target" | Out-Null
    
    Write-ColoredText "Build scheduled successfully as task: $taskName" "Green"
}

#endregion

#region Main Execution

Show-Header
Initialize-BuildEnvironment

# Handle scheduling if requested
if ($Schedule) {
    Schedule-Build -Time $ScheduleTime
    exit 0
}

# Handle build
$exitCode = Invoke-Build -Target $Target

# Calculate total script duration
$endTime = Get-Date
$totalDuration = ($endTime - $startTime).TotalSeconds

Write-ColoredText "Total execution time: $([Math]::Round($totalDuration, 2)) seconds" "Cyan"

exit $exitCode

#endregion
