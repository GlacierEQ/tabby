# Ninja Team Build Orchestrator for Tabby
# Runs multiple coordinated Ninja build processes in parallel for maximum efficiency

param (
    [Parameter(Position=0)]
    [ValidateSet("all", "release", "debug", "cuda", "minimum", "full", "")]
    [string]$BuildMode = "all",
    
    [int]$TeamSize = 0, # 0 = auto-detect
    [switch]$Clean,
    [switch]$Run,
    [switch]$Verbose,
    [switch]$ShowProgress
)

# Initialize colors and console settings
$Host.UI.RawUI.WindowTitle = "Tabby Ninja Team Builder"
$colors = @{
    "Success" = "Green"
    "Error" = "Red"
    "Warning" = "Yellow"
    "Info" = "Cyan"
    "Debug" = "Gray"
    "Emphasis" = "Magenta"
}

# Create timestamp for logs
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$logDir = Join-Path $PSScriptRoot "..\logs"
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}
$masterLogFile = Join-Path $logDir "ninja-team-$timestamp.log"

# Initialize timer
$startTime = Get-Date

function Write-TeamLog {
    param (
        [string]$Message,
        [string]$Level = "Info",
        [switch]$NoNewLine
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $fullMessage = "[$timestamp][$Level] $Message"
    
    # Write to log file
    $fullMessage | Out-File -Append -FilePath $masterLogFile
    
    # Write to console with color
    $color = $colors[$Level]
    if ($NoNewLine) {
        Write-Host $Message -NoNewline -ForegroundColor $color
    } else {
        Write-Host $Message -ForegroundColor $color
    }
}

function Show-NinjaBanner {
    $banner = @"
 _   _ _       _       _____                    
| \ | (_)     (_)     |_   _|                   
|  \| |_ _ __  _  __ _  | | ___  __ _ _ __ ___  
| . ` | | '_ \| |/ _` | | |/ _ \/ _` | '_ ` _ \ 
| |\  | | | | | | (_| | | |  __/ (_| | | | | | |
\_| \_/_|_| |_| |\__,_| \_/\___|\__,_|_| |_| |_|
           _/ |                                 
          |__/                                  

"@
    Write-Host $banner -ForegroundColor Cyan

    Write-TeamLog "NINJA TEAM BUILD SYSTEM" "Emphasis"
    Write-TeamLog "Build Mode: $BuildMode" "Info"
    Write-TeamLog "Log: $masterLogFile" "Debug"
    Write-TeamLog ""
}

function Get-OptimalTeamSize {
    # Get CPU info
    try {
        $cpuInfo = Get-CimInstance -ClassName Win32_Processor
        $totalCores = $cpuInfo.NumberOfCores
        $logicalProcessors = $cpuInfo.NumberOfLogicalProcessors
            
        # Fallback if properties not available
        if (-not $totalCores) { $totalCores = [Environment]::ProcessorCount }
        if (-not $logicalProcessors) { $logicalProcessors = [Environment]::ProcessorCount }
            
        # Calculate memory-based constraints
        $mem = Get-CimInstance -ClassName Win32_ComputerSystem
        $totalMemoryGB = [math]::Round($mem.TotalPhysicalMemory / 1GB, 1)
        $memoryBasedLimit = [math]::Max(2, [math]::Floor($totalMemoryGB / 4))
            
        # Determine optimal team size from all factors
        $cpuBasedSize = [math]::Max(2, [math]::Min($totalCores, $logicalProcessors / 2))
        $optimalSize = [math]::Min($cpuBasedSize, $memoryBasedLimit)
            
        # Cap at reasonable maximum
        $optimalSize = [math]::Min(8, $optimalSize)
            
        return [int]$optimalSize
            
    } catch {
        # Fallback to simple calculation
        return [math]::Max(2, [math]::Min(4, [Environment]::ProcessorCount / 2))
    }
}

function Test-NinjaAvailable {
    try {
        $ninjaVersion = & ninja --version 2>&1
        Write-TeamLog "Detected Ninja version: $ninjaVersion" "Success"
        
        # Add common possible Ninja paths to PATH
        $pythonScripts = "$env:USERPROFILE\AppData\Roaming\Python\Python*\Scripts"
        $ninjaExe = Get-ChildItem -Path $pythonScripts -Filter "ninja.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($ninjaExe) {
            $env:PATH = "$($ninjaExe.DirectoryName);$env:PATH"
        }
        
        return $true
    } catch {
        Write-TeamLog "Ninja build tool not found!" "Error"
        Write-TeamLog "Please install Ninja with: pip install ninja" "Warning"
        return $false
    }
}

function Initialize-BuildEnvironment {
    Write-TeamLog "Initializing build environment..." "Info"
    
    # Ensure we're in the root directory
    $rootDir = Join-Path $PSScriptRoot ".."
    Push-Location $rootDir
    
    # Create build directories if they don't exist
    $buildDirs = @(
        "build\cmake-Release",
        "build\cmake-Debug",
        "build\cmake-CUDA"
    )
    
    foreach ($dir in $buildDirs) {
        if ($Clean -and (Test-Path $dir)) {
            Write-TeamLog "Cleaning $dir..." "Warning"
            Remove-Item -Path $dir -Recurse -Force
        }
        
        if (-not (Test-Path $dir)) {
            Write-TeamLog "Creating $dir..." "Info"
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
        }
    }
    
    # Add Rust to PATH if it exists
    if (Test-Path -Path "$env:USERPROFILE\.cargo\bin") {
        $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
    }
    
    return $rootDir
}

function Invoke-NinjaBuild {
    param (
        [string]$BuildType,
        [string]$BuildDir,
        [int]$JobsPerNinja,
        [string]$LogFile
    )
    
    # Configure with CMake if needed
    if (-not (Test-Path "$BuildDir\build.ninja")) {
        Write-TeamLog "Configuring $BuildType with CMake..." "Info"
        
        $cmakeArgs = @(
            "..\..\" # Path to source
            "-G", "Ninja"
        )
        
        # Set build type
        $cmakeType = if ($BuildType -eq "Debug") { "Debug" } else { "Release" }
        $cmakeArgs += "-DCMAKE_BUILD_TYPE=$cmakeType"
        
        # Add feature flags based on build type
        if ($BuildType -eq "CUDA") {
            $cmakeArgs += "-DTABBY_USE_CUDA=ON"
        }
        
        # Run CMake
        Push-Location $BuildDir
        $cmakeProcess = Start-Process -FilePath "cmake" -ArgumentList $cmakeArgs -NoNewWindow -Wait -PassThru
        Pop-Location
        
        if ($cmakeProcess.ExitCode -ne 0) {
            Write-TeamLog "CMake configuration failed for $BuildType!" "Error"
            return $false
        }
    }
    
    # Run Ninja build
    Write-TeamLog "Starting $BuildType build (Ninja team member with $JobsPerNinja workers)..." "Info"
    
    $ninjaArgs = @(
        "-j", "$JobsPerNinja"
    )
    
    if ($Verbose) {
        $ninjaArgs += "-v"
    }
    
    Push-Location $BuildDir
    $buildOutput = & ninja @ninjaArgs 2>&1
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    # Save build output to log file
    $buildOutput | Out-File -FilePath $LogFile
    
    # Process result
    if ($exitCode -eq 0) {
        Write-TeamLog "$BuildType build succeeded!" "Success"
        return $true
    } else {
        Write-TeamLog "$BuildType build failed with exit code $exitCode" "Error"
        return $false
    }
}

function Show-BuildProgressBar {
    param (
        [string]$BuildType,
        [int]$Completed,
        [int]$Total
    )
    
    $percentComplete = [math]::Round(($Completed / $Total) * 100)
    $progressLength = 30
    $progressChars = [math]::Round(($progressLength * $percentComplete) / 100)
    
    $progressBar = "["
    $progressBar += "#" * $progressChars
    $progressBar += " " * ($progressLength - $progressChars)
    $progressBar += "]"
    
    Write-Host -NoNewline "`r$BuildType build: $progressBar $percentComplete% " -ForegroundColor Yellow
}

function Run-NinjaTeam {
    param (
        [array]$BuildTypes,
        [int]$TeamSize
    )
    
    # Display team configuration
    Write-TeamLog "Deploying Ninja Team with $TeamSize members" "Emphasis"
    Write-TeamLog "Build targets: $($BuildTypes -join ', ')" "Info"
    
    # Calculate jobs per ninja based on team size and targets
    $totalJobs = [Environment]::ProcessorCount
    $jobsPerNinja = [math]::Max(1, [math]::Floor($totalJobs / $TeamSize))
    
    Write-TeamLog "Each ninja will use $jobsPerNinja worker threads" "Info"
    Write-TeamLog "Total CPU utilization: ~$($jobsPerNinja * $TeamSize) of $totalJobs cores" "Info"
    Write-TeamLog ""
    
    # Create job array
    $jobs = @()
    $buildResults = @{}
    
    # Start all ninja processes in parallel
    foreach ($buildType in $BuildTypes) {
        $buildDir = "build\cmake-$buildType"
        $logFile = Join-Path $logDir "ninja-$buildType-$timestamp.log"
        
        # Create scriptblock for job
        $scriptBlock = {
            param ($buildType, $buildDir, $jobsPerNinja, $logFile, $verbose)
            
            # Configure with CMake if needed
            if (-not (Test-Path "$buildDir\build.ninja")) {
                $cmakeArgs = @(
                    "..\..\" # Path to source
                    "-G", "Ninja"
                )
                
                # Set build type
                $cmakeType = if ($buildType -eq "Debug") { "Debug" } else { "Release" }
                $cmakeArgs += "-DCMAKE_BUILD_TYPE=$cmakeType"
                
                # Add feature flags based on build type
                if ($buildType -eq "CUDA") {
                    $cmakeArgs += "-DTABBY_USE_CUDA=ON"
                }
                
                # Run CMake
                Push-Location $buildDir
                & cmake @cmakeArgs | Out-File -FilePath "$logFile.cmake" -Append
                $cmakeExitCode = $LASTEXITCODE
                Pop-Location
                
                if ($cmakeExitCode -ne 0) {
                    return @{
                        BuildType = $buildType
                        Success = $false
                        ExitCode = $cmakeExitCode
                        Stage = "CMake"
                    }
                }
            }
            
            # Run Ninja build
            $ninjaArgs = @(
                "-j", "$jobsPerNinja"
            )
            
            if ($verbose) {
                $ninjaArgs += "-v"
            }
            
            Push-Location $buildDir
            & ninja @ninjaArgs | Out-File -FilePath $logFile -Append
            $ninjaExitCode = $LASTEXITCODE
            Pop-Location
            
            # Return result
            return @{
                BuildType = $buildType
                Success = ($ninjaExitCode -eq 0)
                ExitCode = $ninjaExitCode
                Stage = "Ninja"
            }
        }
        
        # Start background job
        Write-TeamLog "Dispatching ninja for $buildType build..." "Info"
        $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $buildType, $buildDir, $jobsPerNinja, $logFile, $Verbose
        $jobs += @{
            Job = $job
            BuildType = $buildType
            StartTime = Get-Date
            LogFile = $logFile
        }
    }
    
    # Monitor jobs
    $completedCount = 0
    $totalJobs = $jobs.Count
    
    while ($completedCount -lt $totalJobs) {
        $runningJobs = @()
        
        foreach ($jobInfo in $jobs) {
            $job = $jobInfo.Job
            $buildType = $jobInfo.BuildType
            
            if ($job.State -eq "Completed") {
                if (-not $jobInfo.Reported) {
                    $result = Receive-Job $job
                    $jobInfo.Reported = $true
                    $buildResults[$buildType] = $result
                    $completedCount++
                    
                    $duration = (Get-Date) - $jobInfo.StartTime
                    $durationStr = "{0:mm\:ss}" -f $duration
                    
                    if ($result.Success) {
                        Write-TeamLog "✓ $buildType build completed successfully in $durationStr" "Success"
                    } else {
                        Write-TeamLog "✗ $buildType build failed with exit code $($result.ExitCode) ($($result.Stage))" "Error"
                    }
                }
            } else {
                $runningJobs += $buildType
            }
        }
        
        # Show progress if requested
        if ($ShowProgress) {
            Write-Host -NoNewline "`r                                                                                " # Clear line
            Write-Host -NoNewline "`rRunning: $($runningJobs -join ', ') [$completedCount/$totalJobs completed]" -ForegroundColor Cyan
        }
        
        # Short pause before checking again
        Start-Sleep -Milliseconds 500
    }
    
    # Clear progress line
    if ($ShowProgress) {
        Write-Host -NoNewline "`r                                                                                "
        Write-Host -NoNewline "`r"
    }
    
    # Calculate overall build result
    $overallSuccess = $true
    foreach ($result in $buildResults.Values) {
        if (-not $result.Success) {
            $overallSuccess = $false
            break
        }
    }
    
    # Clean up jobs
    $jobs | ForEach-Object { Remove-Job $_.Job -Force }
    
    return $overallSuccess
}

function Run-TabbyAfterBuild {
    if ($Run) {
        Write-TeamLog "Starting Tabby after successful build..." "Emphasis"
        
        # Determine device based on what was built
        $device = "cpu"
        if ($BuildMode -eq "cuda" -or $BuildResults.ContainsKey("CUDA")) {
            $device = "cuda"
        }
        
        # Run Tabby
        try {
            & "$PSScriptRoot\..\run-tabby.bat" $device
        } catch {
            Write-TeamLog "Failed to start Tabby: $_" "Error"
            return $false
        }
    }
    
    return $true
}

# MAIN EXECUTION

# Show banner
Show-NinjaBanner

# Verify ninja is available
if (-not (Test-NinjaAvailable)) {
    exit 1
}

# Set team size
if ($TeamSize -eq 0) {
    $TeamSize = Get-OptimalTeamSize
    Write-TeamLog "Auto-detected optimal team size: $TeamSize ninjas" "Info"
}

# Initialize build environment
$rootDir = Initialize-BuildEnvironment

# Determine build types based on mode
$buildTypes = @()
switch ($BuildMode) {
    "all" {
        $buildTypes = @("Release", "Debug", "CUDA")
    }
    "release" {
        $buildTypes = @("Release")
    }
    "debug" {
        $buildTypes = @("Debug")
    }
    "cuda" {
        $buildTypes = @("CUDA")
    }
    "minimum" {
        $buildTypes = @("Release")
    }
    "full" {
        $buildTypes = @("Release", "Debug", "CUDA")
    }
    default {
        $buildTypes = @("Release", "Debug")
    }
}

# Run the ninja team
Write-TeamLog "Starting coordinated build with $TeamSize ninja processes..." "Emphasis"
$success = Run-NinjaTeam -BuildTypes $buildTypes -TeamSize $TeamSize

# Calculate total build duration
$endTime = Get-Date
$duration = ($endTime - $startTime)
$durationStr = "{0:mm\:ss\.ff}" -f $duration

# Show summary
Write-TeamLog ""
Write-TeamLog "-------------------------------------------" "Info"
if ($success) {
    Write-TeamLog "🏆 All builds completed successfully! 🏆" "Success"
} else {
    Write-TeamLog "⚠️  Some builds failed! Check logs for details ⚠️" "Error"
}
Write-TeamLog "Total build time: $durationStr" "Info"
Write-TeamLog "Log file: $masterLogFile" "Info"
Write-TeamLog "-------------------------------------------" "Info"

# Run Tabby if requested and build was successful
if ($success -and $Run) {
    Run-TabbyAfterBuild
}

# Return to original directory and exit
Pop-Location
exit [int](!$success)
