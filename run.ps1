# PowerShell script for running Tabby with various configurations

param (
    [Parameter(Position=0)]
    [ValidateSet("cpu", "cuda", "rocm", "metal", "vulkan", "auto")]
    [string]$Device = "auto",
    
    [Parameter(Position=1)]
    [string]$Model = "TabbyML/StarCoder-1B",
    
    [int]$Port = 8080,
    
    [switch]$Debug,
    
    [string]$CustomArgs
)

function Write-ColoredText {
    param (
        [string]$Text,
        [string]$Color = "White"
    )
    
    Write-Host $Text -ForegroundColor $Color
}

function Test-Executable {
    $tabbyPath = Join-Path $PSScriptRoot "target\release\tabby.exe"
    if (Test-Path $tabbyPath) {
        return $true
    }
    
    $tabbyDebugPath = Join-Path $PSScriptRoot "target\debug\tabby.exe"
    if ($Debug -and (Test-Path $tabbyDebugPath)) {
        return $true
    }
    
    return $false
}

function Get-BestDevice {
    Write-ColoredText "Auto-detecting best device..." "Cyan"
    
    # Check for CUDA (NVIDIA)
    try {
        $nvidiaGpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "NVIDIA" }
        if ($nvidiaGpu) {
            Write-ColoredText "NVIDIA GPU detected: $($nvidiaGpu.Name)" "Green"
            return "cuda"
        }
    } catch {
        # Continue if checking fails
    }
    
    # Check for AMD GPU (potential ROCm support)
    try {
        $amdGpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -match "AMD|Radeon" }
        if ($amdGpu) {
            Write-ColoredText "AMD GPU detected: $($amdGpu.Name)" "Green"
            return "rocm"
        }
    } catch {
        # Continue if checking fails
    }
    
    # Check for Apple Silicon (Metal)
    if ($PSVersionTable.OS -match "Darwin" -and $PSVersionTable.Platform -eq "Unix") {
        $cpuInfo = & sysctl -n machdep.cpu.brand_string 2>$null
        if ($cpuInfo -match "Apple") {
            Write-ColoredText "Apple Silicon detected: $cpuInfo" "Green"
            return "metal"
        }
    }
    
    # Default to CPU
    Write-ColoredText "No supported GPU detected, using CPU" "Yellow"
    return "cpu"
}

# Display header
Write-ColoredText "====================================" "Cyan"
Write-ColoredText "          TABBY RUNNER (PS1)        " "Cyan"
Write-ColoredText "====================================" "Cyan"
Write-Host ""

# Auto-detect device if necessary
if ($Device -eq "auto") {
    $Device = Get-BestDevice
}

# Determine executable path
$buildType = if ($Debug) { "debug" } else { "release" }
$exePath = Join-Path $PSScriptRoot "target\$buildType\tabby.exe"

# Check if executable exists
if (-not (Test-Path $exePath)) {
    Write-ColoredText "Tabby executable not found at: $exePath" "Red"
    
    $buildChoice = Read-Host "Would you like to build Tabby now? (y/n)"
    if ($buildChoice -eq "y") {
        Write-ColoredText "Building Tabby..." "Cyan"
        
        if ($Debug) {
            & "$PSScriptRoot\WindowsDebugBuild.bat"
        } else {
            & "$PSScriptRoot\WindowsBuild.bat"
        }
        
        if (-not (Test-Path $exePath)) {
            Write-ColoredText "Build failed! Cannot continue." "Red"
            exit 1
        }
    } else {
        Write-ColoredText "Exiting without running." "Yellow"
        exit 1
    }
}

# Display run configuration
Write-ColoredText "Starting Tabby with the following configuration:" "Green"
Write-Host "  - Model: $Model"
Write-Host "  - Device: $Device"
Write-Host "  - Port: $Port"
Write-Host "  - Build Type: $buildType"
if ($CustomArgs) {
    Write-Host "  - Additional arguments: $CustomArgs"
}
Write-Host ""

# Build command arguments
$arguments = @(
    "serve",
    "--model", $Model,
    "--port", $Port
)

if ($Device -ne "cpu") {
    $arguments += "--device"
    $arguments += $Device
}

if ($CustomArgs) {
    $CustomArgs.Split(" ") | ForEach-Object {
        if ($_) { $arguments += $_ }
    }
}

# Show command being executed
$cmdLine = "$exePath " + ($arguments -join " ")
Write-ColoredText "Executing: $cmdLine" "Cyan"
Write-Host ""

# Run Tabby with the specified configuration
& $exePath $arguments

# Wait after exit
Write-Host ""
Write-ColoredText "Tabby has stopped running." "Red"
Read-Host "Press Enter to exit"
