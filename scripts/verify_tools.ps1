# PowerShell script to verify build tools are installed

param (
    [switch]$Quiet
)

$errorCount = 0

function Test-Tool {
    param (
        [string]$Name,
        [string]$InstallMessage,
        [string]$Version = ""
    )
    
    if (-not $Quiet) {
        Write-Host "Checking for $Name..." -NoNewline
    }
    
    if (Get-Command $Name -ErrorAction SilentlyContinue) {
        $versionOutput = ""
        if ($Version -ne "") {
            $versionOutput = & $Name $Version 2>&1
            if (-not $Quiet) {
                Write-Host " Found!" -ForegroundColor Green
                Write-Host "  Version: $versionOutput" -ForegroundColor Gray
            }
        } else {
            if (-not $Quiet) {
                Write-Host " Found!" -ForegroundColor Green
            }
        }
        return $true
    } else {
        if (-not $Quiet) {
            Write-Host " Not found!" -ForegroundColor Red
            Write-Host "  $InstallMessage" -ForegroundColor Yellow
        }
        return $false
    }
}

if (-not $Quiet) {
    Write-Host "====== Tabby Build Tools Verification ======" -ForegroundColor Cyan
    Write-Host ""
}

# Check for CMake
if (-not (Test-Tool -Name "cmake" -InstallMessage "Please install CMake from https://cmake.org/download/" -Version "--version")) {
    $errorCount++
}

# Check for Ninja
if (-not (Test-Tool -Name "ninja" -InstallMessage "Please install Ninja with: pip install ninja" -Version "--version")) {
    $errorCount++
}

# Check for Rust/Cargo
if (-not (Test-Tool -Name "cargo" -InstallMessage "Please install Rust from https://rustup.rs/" -Version "--version")) {
    $errorCount++
}

# Check Git
if (-not (Test-Tool -Name "git" -InstallMessage "Please install Git from https://git-scm.com/download/win" -Version "--version")) {
    $errorCount++
}

# Check system resources
if (-not $Quiet) {
    Write-Host ""
    Write-Host "====== System Resources ======" -ForegroundColor Cyan

    # Check CPU cores
    $cores = [Environment]::ProcessorCount
    Write-Host "CPU Cores: $cores"

    # Check RAM
    $computerSystem = Get-CimInstance -Class Win32_ComputerSystem
    $totalRAMGB = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
    Write-Host "Total RAM: $totalRAMGB GB"

    # Check disk space
    $systemDrive = (Get-PSDrive -Name C).Root
    $disk = Get-CimInstance -Class Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $totalSpaceGB = [math]::Round($disk.Size / 1GB, 2)
    $percentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 0)
    Write-Host "Disk Space (C:): $freeSpaceGB GB free of $totalSpaceGB GB ($percentFree% free)"

    Write-Host ""
}

if ($errorCount -gt 0) {
    if (-not $Quiet) {
        Write-Host "Found $errorCount missing tools that need to be installed" -ForegroundColor Red
        Write-Host "Please install the required tools before building" -ForegroundColor Yellow
    }
    exit 1
} else {
    if (-not $Quiet) {
        Write-Host "All build tools are installed and ready!" -ForegroundColor Green
    }
    exit 0
}
