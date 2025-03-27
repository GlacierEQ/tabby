# Unified Automation System for Tabby - Central automation controller
param(
    [Parameter(Position=0)]
    [ValidateSet("auto", "release", "debug", "cuda", "rocm", "metal", "all", "clean", "verify", "schedule", "run")]
    [string]$Action = "auto",
    
    [switch]$Clean,
    [switch]$Run,
    [switch]$CI,
    [switch]$Install,
    [switch]$Silent,
    [switch]$Force,
    [int]$Parallel = 0,
    [int]$Retries = 0
)

# Initialize environment
$scriptPath = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$logsPath = Join-Path $scriptPath "logs"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = Join-Path $logsPath "autorun_$timestamp.log"

# Create logs directory if it doesn't exist
if (-not (Test-Path $logsPath)) {
    New-Item -Path $logsPath -ItemType Directory -Force | Out-Null
}

function Write-BuildLog {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    if (-not $Silent) {
        Write-Host $Message -ForegroundColor $Color
    }
    
    # Append to log file regardless of Silent mode
    "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message" | Out-File -FilePath $logFile -Append
}

# Detect platform
$isWindows = $PSVersionTable.Platform -eq "Win32NT" -or ($null -eq $PSVersionTable.Platform -and $env:OS -match "Windows")
$isMacOS = $PSVersionTable.OS -match "Darwin" -or (Get-Command "uname" -ErrorAction SilentlyContinue) -and (uname) -eq "Darwin"
$isLinux = $PSVersionTable.OS -match "Linux" -or (Get-Command "uname" -ErrorAction SilentlyContinue) -and (uname) -eq "Linux"

# Display banner
$banner = @"
╔═════════════════════════════════════════════════════╗
║      TABBY AUTOMATED BUILD & EXECUTION SYSTEM       ║
║                                                     ║
║             Platform: $(if($isWindows){"Windows"}elseif($isMacOS){"macOS"}elseif($isLinux){"Linux"}else{"Unknown"})
╚═════════════════════════════════════════════════════╝
"@

Write-BuildLog $banner "Cyan"
Write-BuildLog "Starting automated build process at $(Get-Date)" "Gray"
Write-BuildLog "Action: $Action, Clean: $Clean, Run: $Run, CI: $CI" "Gray"
Write-BuildLog "Log file: $logFile" "Gray"
Write-BuildLog ""

# Detect hardware capabilities
function Get-HardwareInfo {
    Write-BuildLog "Detecting system hardware..." "Cyan"
    
    # CPU info
    try {
        if ($isWindows) {
            $cpuInfo = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
            $cpuName = $cpuInfo.Name
            $cpuCores = $cpuInfo.NumberOfCores
            $cpuLogical = $cpuInfo.NumberOfLogicalProcessors
            
            # Fallback if NumberOfCores isn't available
            if (-not $cpuCores) {
                $cpuCores = [Environment]::ProcessorCount
                $cpuLogical = $cpuCores
            }
        }
        elseif ($isMacOS) {
            $cpuName = $(sysctl -n machdep.cpu.brand_string 2>$null)
            $cpuCores = $(sysctl -n hw.physicalcpu 2>$null)
            $cpuLogical = $(sysctl -n hw.logicalcpu 2>$null)
        }
        elseif ($isLinux) {
            $cpuName = $(grep "model name" /proc/cpuinfo | head -1 | cut -d ":" -f2 | sed 's/^ *//g' 2>$null)
            $cpuCores = $(grep -c "^processor" /proc/cpuinfo 2>$null)
            $cpuLogical = $cpuCores
        }
        else {
            $cpuCores = [Environment]::ProcessorCount
            $cpuLogical = $cpuCores
            $cpuName = "Unknown CPU"
        }
    }
    catch {
        $cpuName = "Unknown CPU"
        $cpuCores = 4
        $cpuLogical = 4
    }
    
    # GPU detection
    $gpuInfo = @{
        HasNvidia = $false
        HasAMD = $false
        HasAppleSilicon = $false
        GPUName = "None detected"
    }
    
    try {
        if ($isWindows) {
            $gpus = Get-CimInstance -ClassName Win32_VideoController
            $nvidiaGPU = $gpus | Where-Object { $_.Name -match "NVIDIA" } | Select-Object -First 1
            $amdGPU = $gpus | Where-Object { $_.Name -match "AMD|Radeon" } | Select-Object -First 1
            
            if ($nvidiaGPU) {
                $gpuInfo.HasNvidia = $true
                $gpuInfo.GPUName = $nvidiaGPU.Name
            }
            elseif ($amdGPU) {
                $gpuInfo.HasAMD = $true
                $gpuInfo.GPUName = $amdGPU.Name
            }
        }
        elseif ($isMacOS) {
            # Check if Apple Silicon
            $cpuInfo = $(sysctl -n machdep.cpu.brand_string 2>$null)
            if ($cpuInfo -match "Apple") {
                $gpuInfo.HasAppleSilicon = $true
                $gpuInfo.GPUName = "Apple Silicon Integrated GPU"
            }
        }
        elseif ($isLinux) {
            # Check for NVIDIA
            $nvidiaCheck = $(lspci | grep -i nvidia 2>$null)
            if ($nvidiaCheck) {
                $gpuInfo.HasNvidia = $true
                $gpuInfo.GPUName = $nvidiaCheck -replace "^.*: ", ""
            }
            
            # Check for AMD
            $amdCheck = $(lspci | grep -i "amd|radeon" 2>$null)
            if ($amdCheck) {
                $gpuInfo.HasAMD = $true
                $gpuInfo.GPUName = $amdCheck -replace "^.*: ", ""
            }
        }
    }
    catch {
        # Use defaults on failure
    }
    
    # Return hardware info
    $hardwareInfo = @{
        CPUName = $cpuName
        CPUCores = $cpuCores
        CPULogical = $cpuLogical
        RecommendedParallel = [Math]::Max(1, [Math]::Min($cpuLogical, 8))
        GPU = $gpuInfo
    }
    
    Write-BuildLog "CPU: $($hardwareInfo.CPUName) ($($hardwareInfo.CPUCores) physical cores, $($hardwareInfo.CPULogical) logical cores)" "Green"
    
    if ($gpuInfo.HasNvidia) {
        Write-BuildLog "GPU: $($gpuInfo.GPUName) (NVIDIA - CUDA build recommended)" "Green"
    }
    elseif ($gpuInfo.HasAMD) {
        Write-BuildLog "GPU: $($gpuInfo.GPUName) (AMD - ROCm build recommended)" "Green"
    }
    elseif ($gpuInfo.HasAppleSilicon) {
        Write-BuildLog "GPU: $($gpuInfo.GPUName) (Metal build recommended)" "Green"
    }
    else {
        Write-BuildLog "GPU: No specialized GPU detected, using CPU build" "Yellow"
    }
    
    return $hardwareInfo
}

# Determine optimal build type
function Get-OptimalBuildType {
    param (
        $HardwareInfo
    )
    
    if ($HardwareInfo.GPU.HasNvidia) {
        return "cuda"
    }
    elseif ($HardwareInfo.GPU.HasAMD) {
        return "rocm"
    }
    elseif ($HardwareInfo.GPU.HasAppleSilicon) {
        return "metal"
    }
    else {
        return "release"
    }
}

# Check and install dependencies
function Install-Dependencies {
    Write-BuildLog "Checking build dependencies..." "Cyan"
    
    if ($isWindows) {
        # Install PowerShell dependencies
        $modules = @("PSYaml")
        foreach ($module in $modules) {
            if (-not (Get-Module -ListAvailable -Name $module)) {
                Write-BuildLog "Installing PowerShell module: $module" "Yellow"
                Install-Module -Name $module -Scope CurrentUser -Force
            }
        }
        
        # Run verification script
        if (Test-Path "$scriptPath\scripts\verify_tools.ps1") {
            & "$scriptPath\scripts\verify_tools.ps1" -Quiet
            
            if ($LASTEXITCODE -ne 0) {
                Write-BuildLog "Installing missing build tools..." "Yellow"
                if (Test-Path "$scriptPath\scripts\install-ninja.ps1") {
                    & "$scriptPath\scripts\install-ninja.ps1"
                }
                if (Test-Path "$scriptPath\scripts\install-cmake.ps1") {
                    & "$scriptPath\scripts\install-cmake.ps1"
                }
            }
        }
    }
    elseif ($isMacOS) {
        # Check for Homebrew and install dependencies
        if (Get-Command "brew" -ErrorAction SilentlyContinue) {
            Write-BuildLog "Updating Homebrew..." "Cyan"
            brew update
            
            # Install required tools
            $brewDeps = @("cmake", "ninja", "openssl", "protobuf")
            foreach ($dep in $brewDeps) {
                Write-BuildLog "Checking for $dep..." -NoNewline
                if (-not (brew list $dep --version 2>$null)) {
                    Write-BuildLog " Installing..." "Yellow"
                    brew install $dep
                }
                else {
                    Write-BuildLog " Already installed" "Green"
                }
            }
        }
        else {
            Write-BuildLog "Homebrew not found. Please install Homebrew: https://brew.sh" "Red"
        }
    }
    elseif ($isLinux) {
        # Try to detect package manager and install dependencies
        if (Get-Command "apt-get" -ErrorAction SilentlyContinue) {
            Write-BuildLog "Detected Debian/Ubuntu system" "Cyan"
            Write-BuildLog "Installing dependencies with apt..." "Yellow"
            sudo apt-get update
            sudo apt-get install -y build-essential cmake ninja-build protobuf-compiler libopenblas-dev
        }
        elseif (Get-Command "dnf" -ErrorAction SilentlyContinue) {
            Write-BuildLog "Detected Fedora/RHEL system" "Cyan"
            Write-BuildLog "Installing dependencies with dnf..." "Yellow"
            sudo dnf install -y gcc gcc-c++ cmake ninja-build protobuf-compiler protobuf-devel openblas-devel
        }
        elseif (Get-Command "pacman" -ErrorAction SilentlyContinue) {
            Write-BuildLog "Detected Arch Linux system" "Cyan"
            Write-BuildLog "Installing dependencies with pacman..." "Yellow"
            sudo pacman -S --needed --noconfirm cmake ninja gcc protobuf openblas
        }
        else {
            Write-BuildLog "Could not detect package manager. Please install build dependencies manually." "Red"
        }
    }
    
    # Check for Rust
    if (-not (Get-Command "rustc" -ErrorAction SilentlyContinue)) {
        Write-BuildLog "Rust not found. Installing..." "Yellow"
        if ($isWindows) {
            Invoke-WebRequest -UseBasicParsing -Uri https://win.rustup.rs/x86_64 -OutFile "$env:TEMP\rustup-init.exe"
            Start-Process -Wait -FilePath "$env:TEMP\rustup-init.exe" -ArgumentList "-y"
            $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
        }
        else {
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            if ($isLinux -or $isMacOS) {
                . "$HOME/.cargo/env"
            }
        }
    }
    
    Write-BuildLog "Dependency check completed" "Green"
}

# Execute build with retry mechanism
function Invoke-TabbyBuild {
    param(
        [string]$BuildType,
        [int]$JobCount,
        [switch]$CleanBuild,
        [int]$RetryCount = 0
    )
    
    Write-BuildLog "Starting build process for type: $BuildType" "Cyan"
    
    $attempt = 0
    $success = $false
    
    while (-not $success -and $attempt -le $RetryCount) {
        $attempt++
        if ($attempt -gt 1) {
            Write-BuildLog "Retry attempt $attempt of $($RetryCount + 1)..." "Yellow"
        }
        
        try {
            if ($isWindows) {
                # Use PowerShell build script on Windows
                $buildArgs = @("-Target", $BuildType)
                if ($CleanBuild) { $buildArgs += "-Clean" }
                if ($JobCount -gt 0) { $buildArgs += "-Parallel", $JobCount }
                if ($CI) { $buildArgs += "-CI" }
                
                if (Test-Path "$scriptPath\build.ps1") {
                    & "$scriptPath\build.ps1" @buildArgs
                }
                elseif (Test-Path "$scriptPath\build-master.ps1") {
                    & "$scriptPath\build-master.ps1" @buildArgs
                }
                elseif (Test-Path "$scriptPath\scripts\build_cmake.ps1") {
                    & "$scriptPath\scripts\build_cmake.ps1" $(if ($BuildType -eq "debug") { "--debug" } elseif ($BuildType -eq "cuda") { "--cuda" })
                }
                else {
                    # Fallback to batch file
                    if ($BuildType -eq "release") {
                        & "$scriptPath\WindowsBuild.bat"
                    }
                    elseif ($BuildType -eq "debug") {
                        & "$scriptPath\WindowsDebugBuild.bat"
                    }
                    elseif ($BuildType -eq "cuda") {
                        & "$scriptPath\WindowsCudaBuild.bat"
                    }
                }
            }
            elseif ($isMacOS -or $isLinux) {
                # Build arguments for shell script
                $shellArgs = ""
                if ($BuildType -eq "debug") { $shellArgs += " --debug" }
                elseif ($BuildType -eq "cuda") { $shellArgs += " --cuda" }
                elseif ($BuildType -eq "rocm") { $shellArgs += " --rocm" }
                elseif ($BuildType -eq "metal") { $shellArgs += " --metal" }
                
                if ($JobCount -gt 0) {
                    $shellArgs += " --parallel=$JobCount --jobs=$JobCount"
                }
                
                if ($CleanBuild) {
                    # Clean first
                    if (Test-Path "build/cmake-*") {
                        Remove-Item -Recurse -Force "build/cmake-*"
                    }
                }
                
                # Execute build
                if ($isMacOS -or $isLinux) {
                    bash -c "chmod +x $scriptPath/scripts/build_cmake.sh && $scriptPath/scripts/build_cmake.sh$shellArgs"
                }
                else {
                    & "$scriptPath/scripts/build_cmake.sh" $shellArgs
                }
            }
            
            if ($LASTEXITCODE -eq 0) {
                $success = $true
                Write-BuildLog "Build completed successfully!" "Green"
            }
            else {
                Write-BuildLog "Build failed with exit code $LASTEXITCODE" "Red"
                if ($attempt -le $RetryCount) {
                    Write-BuildLog "Waiting before retry..." "Yellow"
                    Start-Sleep -Seconds 5
                }
            }
        }
        catch {
            Write-BuildLog "Build process error: $_" "Red"
            if ($attempt -le $RetryCount) {
                Write-BuildLog "Waiting before retry..." "Yellow"
                Start-Sleep -Seconds 5
            }
        }
    }
    
    return $success
}

# Run Tabby after build
function Start-TabbyApplication {
    param(
        [string]$BuildType,
        [string]$Model = "TabbyML/StarCoder-1B"
    )
    
    Write-BuildLog "Starting Tabby application..." "Cyan"
    
    $device = switch ($BuildType) {
        "cuda" { "cuda" }
        "rocm" { "rocm" }
        "metal" { "metal" }
        default { "cpu" }
    }
    
    try {
        if ($isWindows) {
            if (Test-Path "$scriptPath\run-tabby.bat") {
                & "$scriptPath\run-tabby.bat" $device $Model
            }
            elseif (Test-Path "$scriptPath\target\release\tabby.exe") {
                & "$scriptPath\target\release\tabby.exe" serve --model $Model --device $device
            }
        }
        elseif ($isMacOS -or $isLinux) {
            $exePath = "$scriptPath/target/release/tabby"
            if (Test-Path $exePath) {
                bash -c "chmod +x $exePath && $exePath serve --model $Model --device $device"
            }
        }
        
        if ($LASTEXITCODE -ne 0) {
            Write-BuildLog "Application exited with code $LASTEXITCODE" "Yellow"
        }
    }
    catch {
        Write-BuildLog "Error starting application: $_" "Red"
        return $false
    }
    
    return $true
}

# Schedule regular builds
function Set-BuildSchedule {
    if ($isWindows) {
        if (Test-Path "$scriptPath\scheduled-builds.ps1") {
            Write-BuildLog "Scheduling automated builds..." "Cyan"
            & "$scriptPath\scheduled-builds.ps1" -Action create -Schedule daily -BuildType auto
        }
    }
    elseif ($isMacOS -or $isLinux) {
        Write-BuildLog "Setting up cron job for automated builds..." "Cyan"
        $autoRunPath = "$scriptPath/automation/auto-run.ps1"
        $cronJob = "0 3 * * * pwsh -File $autoRunPath auto -Clean -CI"
        
        # Create temporary file with cron job
        $tempFile = New-TemporaryFile
        Write-Output $cronJob | Out-File -FilePath $tempFile
        
        # Add to crontab
        bash -c "crontab -l > /tmp/current_cron || true"
        bash -c "cat $tempFile >> /tmp/current_cron"
        bash -c "crontab /tmp/current_cron"
        bash -c "rm /tmp/current_cron"
        
        # Clean up
        Remove-Item -Path $tempFile
    }
}

# Main automation logic
try {
    # Get hardware information
    $hardwareInfo = Get-HardwareInfo
    
    # Set parallel jobs if not specified
    if ($Parallel -le 0) {
        $Parallel = $hardwareInfo.RecommendedParallel
    }
    
    # Install dependencies if requested
    if ($Install -or $Force) {
        Install-Dependencies
    }
    
    # Process actions
    switch ($Action) {
        "verify" {
            # Just verify the environment
            Install-Dependencies
        }
        "clean" {
            # Clean build directories
            Write-BuildLog "Cleaning build directories..." "Yellow"
            if (Test-Path "$scriptPath\build\cmake-*") {
                Remove-Item -Recurse -Force "$scriptPath\build\cmake-*"
            }
            if (Test-Path "$scriptPath\target") {
                Remove-Item -Recurse -Force "$scriptPath\target"
            }
        }
        "schedule" {
            # Set up scheduled builds
            Set-BuildSchedule
        }
        "auto" {
            # Auto-detect and build optimal configuration
            $optimalType = Get-OptimalBuildType -HardwareInfo $hardwareInfo
            Write-BuildLog "Auto-detected optimal build type: $optimalType" "Green"
            
            # Build the optimal configuration
            $buildSuccess = Invoke-TabbyBuild -BuildType $optimalType -JobCount $Parallel -CleanBuild:$Clean -RetryCount $Retries
            
            # Run if requested and build was successful
            if ($Run -and $buildSuccess) {
                Start-TabbyApplication -BuildType $optimalType
            }
        }
        "all" {
            # Build all configurations
            Write-BuildLog "Building all configurations sequentially..." "Cyan"
            
            $buildTypes = @("release", "debug")
            
            # Add GPU-specific builds if applicable
            if ($hardwareInfo.GPU.HasNvidia) {
                $buildTypes += "cuda"
            }
            elseif ($hardwareInfo.GPU.HasAMD) {
                $buildTypes += "rocm"
            }
            elseif ($hardwareInfo.GPU.HasAppleSilicon) {
                $buildTypes += "metal"
            }
            
            foreach ($type in $buildTypes) {
                Write-BuildLog "Building $type configuration..." "Cyan"
                $typeSuccess = Invoke-TabbyBuild -BuildType $type -JobCount $Parallel -CleanBuild:$Clean -RetryCount $Retries
                
                if (-not $typeSuccess) {
                    Write-BuildLog "Failed to build $type configuration" "Red"
                }
            }
        }
        "run" {
            # Just run the application
            $optimalType = Get-OptimalBuildType -HardwareInfo $hardwareInfo
            Start-TabbyApplication -BuildType $optimalType
        }
        default {
            # Build specific configuration
            $buildSuccess = Invoke-TabbyBuild -BuildType $Action -JobCount $Parallel -CleanBuild:$Clean -RetryCount $Retries
            
            # Run if requested and build was successful
            if ($Run -and $buildSuccess) {
                Start-TabbyApplication -BuildType $Action
            }
        }
    }
}
catch {
    Write-BuildLog "Error in automation process: $_" "Red"
    Write-BuildLog $_.ScriptStackTrace "Red"
    exit 1
}

# Final log entry
Write-BuildLog "Automation completed at $(Get-Date)" "Cyan"
exit 0
