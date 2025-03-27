# Advanced CMake Automation for Tabby - Cross-platform build orchestrator
# This script provides a unified interface for CMake builds across Windows, Linux, and macOS

param (
    [Parameter(Position=0)]
    [ValidateSet("auto", "release", "debug", "cuda", "rocm", "metal", "vulkan", "clean", "verify", "")]
    [string]$BuildType = "auto",

    [switch]$Clean,
    [switch]$Parallel,
    [int]$Jobs = 0,
    [switch]$Verbose,
    [switch]$Install,
    [switch]$Run,
    [switch]$Export,
    [string]$ExportDir,
    [switch]$NoInteractive,
    [string]$Generator = "Ninja"
)

# Determine platform
$isWindows = $env:OS -match "Windows"
$isMacOS = (Get-Command "uname" -ErrorAction SilentlyContinue) -and (uname) -eq "Darwin"
$isLinux = (Get-Command "uname" -ErrorAction SilentlyContinue) -and (uname) -eq "Linux"
$isInteractive = [Environment]::UserInteractive -and (-not $NoInteractive)

# Setup console colors if in interactive mode
if ($isInteractive) {
    $colors = @{
        "Success" = "Green"
        "Error" = "Red"
        "Warning" = "Yellow"
        "Info" = "Cyan"
        "Debug" = "Gray"
        "Heading" = "Magenta"
    }
}

# Set up logging
$logDir = Join-Path $PSScriptRoot "logs"
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile = Join-Path $logDir "cmake-build-$timestamp.log"

function Write-BuildLog {
    param (
        [string]$Message,
        [string]$Level = "Info",
        [switch]$NoNewLine
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $prefix = "[$timestamp][$Level]"
    $fullMessage = "$prefix $Message"
    
    # Always write to log file
    $fullMessage | Out-File -Append -FilePath $logFile
    
    # Write to console with color if interactive
    if ($isInteractive) {
        $color = $colors[$Level]
        if ($NoNewLine) {
            Write-Host $Message -NoNewline -ForegroundColor $color
        } else {
            Write-Host $Message -ForegroundColor $color
        }
    }
}

function Write-Separator {
    Write-BuildLog "------------------------------------------------------" -Level "Info"
}

function Initialize-BuildEnvironment {
    Write-BuildLog "Initializing build environment..." -Level "Heading"
    
    # Create directories
    $dirs = @(
        (Join-Path $PSScriptRoot "build"), 
        (Join-Path $PSScriptRoot "logs"), 
        (Join-Path $PSScriptRoot ".cmake")
    )
    
    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
            Write-BuildLog "Created directory: $dir"
        }
    }
    
    # Add tools to PATH
    $pathsToAdd = @()
    
    # Add Rust to PATH if it exists
    if (Test-Path -Path "$env:USERPROFILE\.cargo\bin") {
        $pathsToAdd += "$env:USERPROFILE\.cargo\bin"
    }
    
    # Add Python-installed Ninja to PATH if it exists
    $pythonNinjaPath = "$env:USERPROFILE\AppData\Roaming\Python\Python*\Scripts"
    $ninjaExe = Get-ChildItem -Path $pythonNinjaPath -Filter "ninja.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($ninjaExe) {
        $pathsToAdd += $ninjaExe.DirectoryName
    }
    
    # Add CMake to PATH if installed in common location
    $cmakePaths = @(
        "C:\Program Files\CMake\bin",
        "C:\Program Files (x86)\CMake\bin"
    )
    
    foreach ($path in $cmakePaths) {
        if (Test-Path "$path\cmake.exe") {
            $pathsToAdd += $path
        }
    }
    
    # Add paths to current session
    foreach ($path in $pathsToAdd) {
        if (-not $env:PATH.Contains($path)) {
            $env:PATH = "$path;$env:PATH"
            Write-BuildLog "Added to PATH: $path"
        }
    }
    
    # Determine optimal job count for parallel builds if not specified
    if ($Jobs -eq 0) {
        $physicalCores = 0
        try {
            if ($isWindows) {
                $physicalCores = (Get-CimInstance -ClassName Win32_Processor).NumberOfCores
            } elseif ($isMacOS) {
                $physicalCores = [int](sysctl -n hw.physicalcpu)
            } elseif ($isLinux) {
                $physicalCores = [int](lscpu -p | grep -v '^#' | sort -u -t, -k 2,4 | wc -l)
            }
        } catch {
            # Fallback
        }
        
        if ($physicalCores -le 0) {
            $physicalCores = [Environment]::ProcessorCount
        }
        
        # Use physical cores + 1 for best performance
        $Jobs = [Math]::Min([Environment]::ProcessorCount, $physicalCores + 1)
        Write-BuildLog "Automatically set parallel jobs to $Jobs"
    }
}

function Test-BuildTools {
    Write-BuildLog "Checking build tools..." -Level "Heading"
    $missingTools = @()
    
    # Check for CMake
    try {
        $cmakeVersion = & cmake --version | Select-Object -First 1
        Write-BuildLog "Found $cmakeVersion"
    } catch {
        $missingTools += "CMake"
        Write-BuildLog "CMake not found or not in PATH" -Level "Error"
    }
    
    # Check for Ninja if using Ninja generator
    if ($Generator -eq "Ninja") {
        try {
            $ninjaVersion = & ninja --version
            Write-BuildLog "Found Ninja v$ninjaVersion"
        } catch {
            $missingTools += "Ninja"
            Write-BuildLog "Ninja not found or not in PATH" -Level "Error"
        }
    }
    
    # Check for Rust
    try {
        $rustVersion = & rustc --version
        Write-BuildLog "Found $rustVersion"
    } catch {
        $missingTools += "Rust"
        Write-BuildLog "Rust not found or not in PATH" -Level "Error"
    }
    
    # Check for Git
    try {
        $gitVersion = & git --version
        Write-BuildLog "Found $gitVersion"
    } catch {
        $missingTools += "Git"
        Write-BuildLog "Git not found or not in PATH" -Level "Warning"
    }
    
    # Install missing tools if requested
    if ($missingTools.Count -gt 0 -and $Install) {
        Write-BuildLog "Installing missing tools: $($missingTools -join ", ")..." -Level "Warning"
        
        if ($missingTools -contains "CMake" -and (Test-Path "$PSScriptRoot\scripts\install-cmake.ps1")) {
            Write-BuildLog "Installing CMake..."
            & "$PSScriptRoot\scripts\install-cmake.ps1"
        }
        
        if ($missingTools -contains "Ninja" -and (Test-Path "$PSScriptRoot\scripts\install-ninja.ps1")) {
            Write-BuildLog "Installing Ninja..."
            & "$PSScriptRoot\scripts\install-ninja.ps1"
        }
        
        if ($missingTools -contains "Rust") {
            Write-BuildLog "Installing Rust..."
            if ($isWindows) {
                Invoke-WebRequest -Uri https://win.rustup.rs/x86_64 -OutFile "$env:TEMP\rustup-init.exe"
                Start-Process -FilePath "$env:TEMP\rustup-init.exe" -ArgumentList "-y" -Wait
            } else {
                & curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            }
        }
        
        return $false
    }
    
    return ($missingTools.Count -eq 0)
}

function Detect-OptimalBuildType {
    if ($BuildType -ne "auto") {
        return $BuildType
    }
    
    Write-BuildLog "Detecting optimal build type based on hardware..." -Level "Info"
    
    # Check for NVIDIA GPU
    $hasNvidia = $false
    if ($isWindows) {
        $gpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "NVIDIA" }
        $hasNvidia = ($gpu -ne $null)
    } elseif ($isLinux) {
        $lspciOutput = & lspci 2>$null
        $hasNvidia = $lspciOutput -match "NVIDIA"
    }
    
    if ($hasNvidia) {
        Write-BuildLog "Detected NVIDIA GPU, using CUDA build" -Level "Success"
        return "cuda"
    }
    
    # Check for AMD GPU
    $hasAMD = $false
    if ($isWindows) {
        $gpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "AMD|Radeon" }
        $hasAMD = ($gpu -ne $null)
    } elseif ($isLinux) {
        $lspciOutput = & lspci 2>$null
        $hasAMD = $lspciOutput -match "AMD|Radeon"
    }
    
    if ($hasAMD) {
        Write-BuildLog "Detected AMD GPU, using ROCm build" -Level "Success"
        return "rocm"
    }
    
    # Check for macOS Metal
    if ($isMacOS) {
        $sysctl = & sysctl -n machdep.cpu.brand_string 2>$null
        if ($sysctl -match "Apple") {
            Write-BuildLog "Detected Apple Silicon, using Metal build" -Level "Success"
            return "metal"
        }
    }
    
    # Default to release
    Write-BuildLog "No specialized hardware detected, using standard release build" -Level "Info"
    return "release"
}

function Clean-BuildDirectories {
    param (
        [string]$Type = "all"
    )
    
    Write-BuildLog "Cleaning build directories for: $Type" -Level "Warning"
    
    if ($Type -eq "all") {
        # Clean all build directories
        $buildDirs = Join-Path $PSScriptRoot "build\cmake-*"
        if (Test-Path $buildDirs) {
            Remove-Item -Path $buildDirs -Recurse -Force
            Write-BuildLog "Removed all CMake build directories" -Level "Success"
        } else {
            Write-BuildLog "No CMake build directories to clean" -Level "Info"
        }
    } else {
        # Clean specific build directory
        $buildDir = Join-Path $PSScriptRoot "build\cmake-$Type"
        if (Test-Path $buildDir) {
            Remove-Item -Path $buildDir -Recurse -Force
            Write-BuildLog "Removed build directory: $buildDir" -Level "Success"
        } else {
            Write-BuildLog "No build directory to clean for type: $Type" -Level "Info"
        }
    }
}

function Start-CMakeBuild {
    param (
        [string]$Type
    )
    
    $cmakeType = if ($Type -eq "debug") { "Debug" } else { "Release" }
    $buildDir = Join-Path $PSScriptRoot "build\cmake-$Type"
    
    # Create build directory if it doesn't exist
    if (-not (Test-Path $buildDir)) {
        New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    }
    
    # Define CMake arguments based on build type
    $cmakeArgs = @(
        "..\..\" # Path to source
        "-G", "$Generator"
        "-DCMAKE_BUILD_TYPE=$cmakeType"
    )
    
    # Add feature flags based on build type
    switch ($Type) {
        "cuda" { $cmakeArgs += "-DTABBY_USE_CUDA=ON" }
        "rocm" { $cmakeArgs += "-DTABBY_USE_ROCM=ON" }
        "metal" { $cmakeArgs += "-DTABBY_USE_METAL=ON" }
        "vulkan" { $cmakeArgs += "-DTABBY_USE_VULKAN=ON" }
    }
    
    # Add verbose flag if requested
    if ($Verbose) {
        $cmakeArgs += "-DCMAKE_VERBOSE_MAKEFILE=ON"
    }
    
    # Add parallel level flag
    $cmakeArgs += "-DTABBY_PARALLEL_LEVEL=$Jobs"
    
    # Get into the build directory
    Push-Location $buildDir
    try {
        # Configure step
        Write-BuildLog "Configuring CMake for $Type build in $buildDir..." -Level "Info"
        $configStartTime = Get-Date
        & cmake @cmakeArgs
        if ($LASTEXITCODE -ne 0) {
            Write-BuildLog "CMake configuration failed with error code $LASTEXITCODE" -Level "Error"
            return $false
        }
        $configEndTime = Get-Date
        $configDuration = ($configEndTime - $configStartTime).TotalSeconds
        Write-BuildLog "CMake configuration completed in $($configDuration.ToString('0.0')) seconds" -Level "Success"
        
        # Build step
        Write-BuildLog "Building with CMake for $Type (using $Jobs jobs)..." -Level "Info"
        $buildStartTime = Get-Date
        
        # Set build arguments
        $buildArgs = @(
            "--build", ".",
            "--config", "$cmakeType"
        )
        
        # Add parallel flag based on generator
        if ($Generator -eq "Ninja") {
            $buildArgs += "--", "-j$Jobs"
        } else {
            $buildArgs += "--parallel", "$Jobs"
        }
        
        # Run the build
        & cmake @buildArgs
        
        if ($LASTEXITCODE -ne 0) {
            Write-BuildLog "Build failed with error code $LASTEXITCODE" -Level "Error"
            return $false
        }
        
        $buildEndTime = Get-Date
        $buildDuration = ($buildEndTime - $buildStartTime).TotalSeconds
        Write-BuildLog "Build completed in $($buildDuration.ToString('0.0')) seconds" -Level "Success"
        
        # Export if requested
        if ($Export) {
            Export-BuildArtifacts -Type $Type -Directory $ExportDir
        }
        
        return $true
    }
    finally {
        # Return to the original directory
        Pop-Location
    }
}

function Export-BuildArtifacts {
    param (
        [string]$Type,
        [string]$Directory
    )
    
    # If no directory specified, use a default
    if (-not $Directory) {
        $Directory = Join-Path $PSScriptRoot "dist\$Type-$timestamp"
    }
    
    # Create export directory if it doesn't exist
    if (-not (Test-Path $Directory)) {
        New-Item -Path $Directory -ItemType Directory -Force | Out-Null
    }
    
    Write-BuildLog "Exporting build artifacts to $Directory..." -Level "Info"
    
    # Find the binaries
    $binDir = Join-Path $PSScriptRoot "target\release"
    if ($Type -eq "debug") {
        $binDir = Join-Path $PSScriptRoot "target\debug"
    }
    
    if (-not (Test-Path $binDir)) {
        Write-BuildLog "Binary directory not found: $binDir" -Level "Error"
        return $false
    }
    
    # Copy the binaries
    $exeFiles = Get-ChildItem -Path $binDir -Filter "*.exe" | Select-Object -ExpandProperty FullName
    foreach ($file in $exeFiles) {
        Copy-Item -Path $file -Destination $Directory -Force
        Write-BuildLog "Exported: $file" -Level "Success"
    }
    
    # Copy any DLLs if on Windows
    if ($isWindows) {
        $dllFiles = Get-ChildItem -Path $binDir -Filter "*.dll" | Select-Object -ExpandProperty FullName
        foreach ($file in $dllFiles) {
            Copy-Item -Path $file -Destination $Directory -Force
            Write-BuildLog "Exported: $file" -Level "Success"
        }
    }
    
    # Create a build info file
    $buildInfoFile = Join-Path $Directory "build-info.txt"
    @"
Tabby Build Information
Build Type: $Type
Build Time: $(Get-Date)
Platform: $($isWindows ? "Windows" : ($isMacOS ? "macOS" : "Linux"))
CMake Version: $(& cmake --version | Select-Object -First 1)
Generator: $Generator
"@ | Out-File -FilePath $buildInfoFile -Encoding UTF8
    
    Write-BuildLog "Exported build info to: $buildInfoFile" -Level "Success"
    return $true
}

function Run-TabbyAfterBuild {
    param (
        [string]$Type
    )
    
    Write-BuildLog "Starting Tabby after build..." -Level "Heading"
    
    # Determine executable path
    $exePath = Join-Path $PSScriptRoot "target\release\tabby"
    if ($isWindows) {
        $exePath += ".exe"
    }
    
    if (-not (Test-Path $exePath)) {
        Write-BuildLog "Tabby executable not found at: $exePath" -Level "Error"
        return $false
    }
    
    # Determine device based on build type
    $device = "cpu"
    switch ($Type) {
        "cuda" { $device = "cuda" }
        "rocm" { $device = "rocm" }
        "metal" { $device = "metal" }
        "vulkan" { $device = "vulkan" }
    }
    
    # Build the arguments
    $tabbyArgs = @(
        "serve",
        "--model", "TabbyML/StarCoder-1B"
    )
    
    # Add device if not CPU
    if ($device -ne "cpu") {
        $tabbyArgs += "--device", $device
    }
    
    # Run Tabby
    Write-BuildLog "Running Tabby with device: $device" -Level "Info"
    & $exePath @tabbyArgs
    
    return ($LASTEXITCODE -eq 0)
}

function Show-BuildSummary {
    param (
        [string]$Type,
        [bool]$Success,
        [DateTime]$StartTime,
        [DateTime]$EndTime
    )
    
    $duration = ($EndTime - $StartTime).TotalSeconds
    
    Write-Separator
    if ($Success) {
        Write-BuildLog "BUILD SUCCEEDED for type: $Type" -Level "Success"
    } else {
        Write-BuildLog "BUILD FAILED for type: $Type" -Level "Error"
    }
    
    Write-BuildLog "Total time elapsed: $($duration.ToString('0.0')) seconds" -Level "Info"
    Write-BuildLog "Log file: $logFile" -Level "Info"
    
    # Check if the binary was created
    $exePath = Join-Path $PSScriptRoot "target\release\tabby"
    if ($Type -eq "debug") {
        $exePath = Join-Path $PSScriptRoot "target\debug\tabby"
    }
    if ($isWindows) {
        $exePath += ".exe"
    }
    
    if (Test-Path $exePath) {
        Write-BuildLog "Executable created at: $exePath" -Level "Success"
    } else {
        Write-BuildLog "Executable not found at: $exePath" -Level "Warning"
    }
    
    Write-Separator
}

##### Main Script Execution #####

# Display header
$banner = @"
╔═════════════════════════════════════════════╗
║       TABBY CMAKE AUTOMATION SYSTEM         ║
╚═════════════════════════════════════════════╝
"@

Write-BuildLog $banner -Level "Heading"
Write-BuildLog "Starting CMake build process at $(Get-Date)" -Level "Info"
Write-BuildLog "Build type: $BuildType, Clean: $Clean, Parallel: $Parallel, Jobs: $Jobs, Generator: $Generator" -Level "Info"
Write-BuildLog "Log file: $logFile" -Level "Info"
Write-Separator

$startTime = Get-Date
$success = $true

# Initialize environment
Initialize-BuildEnvironment

# Handle 'verify' command
if ($BuildType -eq "verify") {
    $success = Test-BuildTools
    if ($success) {
        Write-BuildLog "All required build tools are installed and ready!" -Level "Success"
    } else {
        Write-BuildLog "Some required build tools are missing." -Level "Error"
    }
    exit [int](!$success)
}

# Handle 'clean' command
if ($BuildType -eq "clean") {
    Clean-BuildDirectories
    exit 0
}

# Clean if requested
if ($Clean) {
    Clean-BuildDirectories -Type $BuildType
}

# Determine build type if auto
if ($BuildType -eq "auto") {
    $BuildType = Detect-OptimalBuildType
}

# Verify build tools
if (-not (Test-BuildTools)) {
    exit 1
}

# Perform the build
$success = Start-CMakeBuild -Type $BuildType

# Run after build if requested and build succeeded
if ($Run -and $success) {
    Run-TabbyAfterBuild -Type $BuildType
}

# Show build summary
$endTime = Get-Date
Show-BuildSummary -Type $BuildType -Success $success -StartTime $startTime -EndTime $endTime

# Exit with appropriate code
exit [int](!$success)
