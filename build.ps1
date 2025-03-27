# Unified Build System for Tabby - Platform-independent entry point with auto-configuration
param (
    [Parameter(Position=0)]
    [ValidateSet("auto", "release", "debug", "cuda", "rocm", "metal", "all", "clean", "evolution", "")]
    [string]$Target = "auto",
    
    [switch]$Clean,
    [switch]$Run,
    [switch]$CI,
    [switch]$Install,
    [switch]$Verify,
    [switch]$Schedule,
    [int]$Parallel = 0,
    [switch]$NoPrompt,
    [switch]$Learn
)

# Initialize environment
$scriptPath = $PSScriptRoot
$startTime = Get-Date
$isWindows = $env:OS -match "Windows"
$isMacOS = (Get-Command "uname" -ErrorAction SilentlyContinue) -and (uname) -eq "Darwin"
$isLinux = (Get-Command "uname" -ErrorAction SilentlyContinue) -and (uname) -eq "Linux"
$logDirectory = Join-Path $scriptPath "logs"
$configDirectory = Join-Path $scriptPath "configs"
$buildDirectory = Join-Path $scriptPath "build"

# Create required directories
foreach ($dir in @($logDirectory, $configDirectory, $buildDirectory)) {
    if (-not (Test-Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
    }
}

# Set up log file
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile = Join-Path $logDirectory "build-$timestamp.log"

function Write-Log {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    # Write to console with color
    Write-Host $Message -ForegroundColor $Color
    
    # Also write to log file without color
    $Message | Out-File -FilePath $logFile -Append
}

# Display header
function Show-Header {
    $banner = @"
╔═════════════════════════════════════════════╗
║        TABBY UNIFIED BUILD SYSTEM           ║
║                                             ║
║   Auto-detecting platform and hardware...   ║
╚═════════════════════════════════════════════╝
"@
    Write-Log $banner "Cyan"
    Write-Log "Build started at: $(Get-Date)" "Gray"
    
    # Detect platform
    if ($isWindows) {
        Write-Log "Platform detected: Windows" "Green"
    } elseif ($isMacOS) {
        Write-Log "Platform detected: macOS" "Green"
    } elseif ($isLinux) {
        Write-Log "Platform detected: Linux" "Green"
    } else {
        Write-Log "Platform could not be detected" "Yellow"
    }
    
    # Detect hardware
    try {
        if ($isWindows) {
            $gpus = Get-CimInstance -ClassName Win32_VideoController
            $hasNvidia = $gpus | Where-Object { $_.Name -match "NVIDIA" }
            $hasAMD = $gpus | Where-Object { $_.Name -match "AMD|Radeon" }
            
            if ($hasNvidia) {
                Write-Log "NVIDIA GPU detected: $($hasNvidia.Name)" "Green"
            }
            if ($hasAMD) {
                Write-Log "AMD GPU detected: $($hasAMD.Name)" "Green"
            }
            if (-not $hasNvidia -and -not $hasAMD) {
                Write-Log "No supported GPU detected. Using CPU build." "Yellow"
            }
        } elseif ($isMacOS) {
            $cpuInfo = & sysctl -n machdep.cpu.brand_string 2>$null
            if ($cpuInfo -match "Apple") {
                Write-Log "Apple Silicon detected: $cpuInfo" "Green"
            } else {
                Write-Log "Intel Mac detected: $cpuInfo" "Green"
            }
        } elseif ($isLinux) {
            $hasNvidia = & bash -c "lspci | grep -i nvidia" 2>$null
            $hasAMD = & bash -c "lspci | grep -i amd" 2>$null
            
            if ($hasNvidia) {
                Write-Log "NVIDIA GPU detected" "Green"
            }
            if ($hasAMD) {
                Write-Log "AMD GPU detected" "Green"
            }
            if (-not $hasNvidia -and -not $hasAMD) {
                Write-Log "No supported GPU detected. Using CPU build." "Yellow"
            }
        }
    } catch {
        Write-Log "Could not detect hardware: $_" "Red"
    }
    
    # Show selected build target
    Write-Log ""
    Write-Log "Selected build target: $Target" "Magenta"
    if ($Clean) { Write-Log "Clean build: Yes" "Magenta" }
    if ($Run) { Write-Log "Run after build: Yes" "Magenta" }
    if ($CI) { Write-Log "CI mode: Yes" "Magenta" }
    if ($Parallel -gt 0) { Write-Log "Parallel jobs: $Parallel" "Magenta" }
    Write-Log ""
}

# Auto-detect best build target based on hardware
function Get-OptimalBuildTarget {
    if ($Target -ne "auto") { return $Target }
    
    if ($isWindows) {
        $hasNvidia = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "NVIDIA" }
        $hasAMD = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "AMD|Radeon" }
        
        if ($hasNvidia) {
            return "cuda"
        } elseif ($hasAMD) {
            return "rocm"
        } else {
            return "release"
        }
    } elseif ($isMacOS) {
        $cpuInfo = & sysctl -n machdep.cpu.brand_string 2>$null
        if ($cpuInfo -match "Apple") {
            return "metal"
        } else {
            return "release"
        }
    } elseif ($isLinux) {
        $hasNvidia = & bash -c "lspci | grep -i nvidia" 2>$null
        $hasAMD = & bash -c "lspci | grep -i amd" 2>$null
        
        if ($hasNvidia) {
            return "cuda"
        } elseif ($hasAMD) {
            return "rocm"
        } else {
            return "release"
        }
    } else {
        return "release"
    }
}

# Execute build based on platform
function Invoke-BuildProcess {
    param (
        [string]$BuildTarget
    )
    
    # Build parameters
    $buildParams = @()
    if ($BuildTarget) { $buildParams += "-Target", $BuildTarget }
    if ($Clean) { $buildParams += "-Clean" }
    if ($Run) { $buildParams += "-Run" }
    if ($CI) { $buildParams += "-Quiet" }
    if ($NoPrompt) { $buildParams += "-NoPrompt" }
    if ($Learn) { $buildParams += "-Learn" }
    if ($Parallel -gt 0) { $buildParams += "-ParallelJobs", $Parallel }
    
    Write-Log "Executing build with target: $BuildTarget" "Cyan"
    
    try {
        if ($isWindows) {
            # Use the PowerShell build master on Windows
            & "$scriptPath\build-master.ps1" @buildParams
            return $LASTEXITCODE
        } elseif ($isMacOS -or $isLinux) {
            # Use the shell script on macOS/Linux
            $bashParams = ""
            
            if ($Clean) { $bashParams += " --clean" }
            
            switch ($BuildTarget) {
                "release" { }  # Default is release
                "debug" { $bashParams += " --debug" }
                "cuda" { $bashParams += " --cuda" }
                "rocm" { $bashParams += " --rocm" }
                "metal" { $bashParams += " --metal" }
            }
            
            if ($Parallel -gt 0) { 
                $bashParams += " --parallel=$Parallel"
                $bashParams += " --jobs=$Parallel"
            }
            
            $scriptToRun = if ($isMacOS -or $isLinux) {
                "$scriptPath/scripts/build_cmake.sh"
            } else {
                "$scriptPath\scripts\build_cmake.sh"  # Fallback
            }
            
            # Make sure the script is executable on Unix systems
            if ($isMacOS -or $isLinux) {
                & bash -c "chmod +x $scriptToRun"
            }
            
            # Execute the build script
            if ($isMacOS -or $isLinux) {
                & bash -c "$scriptToRun$bashParams"
            } else {
                & $scriptToRun $bashParams
            }
            
            return $LASTEXITCODE
        } else {
            Write-Log "Unsupported platform for build" "Red"
            return 1
        }
    } catch {
        Write-Log "Error during build execution: $_" "Red"
        return 1
    }
}

# Install dependencies if needed
function Install-Dependencies {
    Write-Log "Checking and installing dependencies..." "Cyan"
    
    try {
        if ($isWindows) {
            # Windows: Use the verify_tools script
            & "$scriptPath\scripts\verify_tools.ps1" -Quiet
            
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Installing missing build tools..." "Yellow"
                & "$scriptPath\scripts\install-ninja.ps1"
                & "$scriptPath\scripts\install-cmake.ps1"
            } else {
                Write-Log "All required tools are installed" "Green"
            }
        } elseif ($isMacOS) {
            # macOS: Check for brew, cmake, ninja
            $hasBrew = Get-Command "brew" -ErrorAction SilentlyContinue
            
            if (-not $hasBrew) {
                Write-Log "Homebrew not found. Please install it first: https://brew.sh" "Red"
                return 1
            }
            
            $hasCMake = Get-Command "cmake" -ErrorAction SilentlyContinue
            $hasNinja = Get-Command "ninja" -ErrorAction SilentlyContinue
            
            if (-not $hasCMake) {
                Write-Log "Installing CMake..." "Yellow"
                & brew install cmake
            }
            
            if (-not $hasNinja) {
                Write-Log "Installing Ninja..." "Yellow"
                & brew install ninja
            }
            
            # Check for Rust
            $hasRust = Get-Command "cargo" -ErrorAction SilentlyContinue
            
            if (-not $hasRust) {
                Write-Log "Installing Rust..." "Yellow"
                & curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            }
        } elseif ($isLinux) {
            # Linux: Check for apt/dnf/pacman, install deps
            $hasApt = Get-Command "apt-get" -ErrorAction SilentlyContinue
            $hasDnf = Get-Command "dnf" -ErrorAction SilentlyContinue
            $hasPacman = Get-Command "pacman" -ErrorAction SilentlyContinue
            
            if ($hasApt) {
                Write-Log "Debian/Ubuntu detected, checking packages..." "Yellow"
                & bash -c "sudo apt-get update && sudo apt-get install -y cmake ninja-build build-essential"
            } elseif ($hasDnf) {
                Write-Log "Fedora/RHEL detected, checking packages..." "Yellow"
                & bash -c "sudo dnf install -y cmake ninja-build gcc gcc-c++"
            } elseif ($hasPacman) {
                Write-Log "Arch Linux detected, checking packages..." "Yellow"
                & bash -c "sudo pacman -S --needed cmake ninja gcc"
            } else {
                Write-Log "Could not detect package manager. Please install cmake and ninja manually." "Red"
                return 1
            }
            
            # Check for Rust
            $hasRust = Get-Command "cargo" -ErrorAction SilentlyContinue
            
            if (-not $hasRust) {
                Write-Log "Installing Rust..." "Yellow"
                & curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            }
        }
        
        return 0
    } catch {
        Write-Log "Error installing dependencies: $_" "Red"
        return 1
    }
}

# Main execution
Show-Header

# Install dependencies if requested
if ($Install) {
    $depResult = Install-Dependencies
    if ($depResult -ne 0) {
        Write-Log "Failed to install dependencies. Aborting build." "Red"
        exit $depResult
    }
}

# Just verify tools if requested
if ($Verify) {
    Write-Log "Verifying build environment..." "Cyan"
    if ($isWindows) {
        & "$scriptPath\scripts\verify_tools.ps1"
    } else {
        if ($isLinux -or $isMacOS) {
            $cmakeVersion = & bash -c "cmake --version | head -n 1" 2>$null
            $ninjaVersion = & bash -c "ninja --version" 2>$null
            $rustVersion = & bash -c "rustc --version" 2>$null
            
            Write-Log "CMake: $cmakeVersion" "Green"
            Write-Log "Ninja: $ninjaVersion" "Green"
            Write-Log "Rust: $rustVersion" "Green"
        } else {
            Write-Log "Verification not supported on this platform" "Red"
        }
    }
    exit 0
}

# Schedule builds if requested
if ($Schedule) {
    Write-Log "Scheduling builds is currently only supported on Windows. Use cron on Unix systems." "Yellow"
    if ($isWindows) {
        & "$scriptPath\scheduled-builds.ps1" -Action create -Schedule daily -BuildType $Target
    }
    exit 0
}

# Get optimal build target if set to auto
if ($Target -eq "auto") {
    $Target = Get-OptimalBuildTarget
    Write-Log "Auto-selected build target: $Target" "Green"
}

# Handle special case for "evolution" build type
if ($Target -eq "evolution") {
    if ($isWindows) {
        & "$scriptPath\build-master.ps1" -Target evolve
        exit $LASTEXITCODE
    } else {
        Write-Log "Evolution builds are only supported on Windows" "Yellow"
        exit 1
    }
}

# Handle clean target
if ($Target -eq "clean") {
    Write-Log "Cleaning all build artifacts..." "Yellow"
    
    if ($isWindows) {
        if (Test-Path "$scriptPath\build\cmake-*") {
            Remove-Item -Path "$scriptPath\build\cmake-*" -Recurse -Force
        }
        if (Test-Path "$scriptPath\target") {
            Remove-Item -Path "$scriptPath\target" -Recurse -Force
        }
    } elseif ($isMacOS -or $isLinux) {
        & bash -c "rm -rf $scriptPath/build/cmake-* $scriptPath/target"
    }
    
    Write-Log "Clean completed" "Green"
    exit 0
}

# Execute build with appropriate parameters
$buildResult = Invoke-BuildProcess -BuildTarget $Target

# Calculate and show total build time
$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds
Write-Log ""
Write-Log "Build $($buildResult -eq 0 ? 'completed successfully' : 'failed')" $($buildResult -eq 0 ? 'Green' : 'Red')
Write-Log "Total execution time: $([Math]::Round($duration, 2)) seconds" "Cyan"
Write-Log "Log saved to: $logFile" "Gray"

exit $buildResult
