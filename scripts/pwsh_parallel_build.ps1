# filepath: C:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\scripts\pwsh_parallel_build.ps1
# PowerShell script for running multiple build jobs in parallel

# Parse command line arguments
param (
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

$Debug = $false
$Cuda = $false
$CustomJobs = 0

# Parse arguments manually
foreach ($arg in $Args) {
    if ($arg -eq "-Debug" -or $arg -eq "--debug") {
        $Debug = $true
    }
    elseif ($arg -eq "-Cuda" -or $arg -eq "--cuda") {
        $Cuda = $true
    }
    elseif ($arg -match "^-?-?(?:CustomJobs|parallel|jobs)=(.+)$") {
        $CustomJobs = [int]$Matches[1]
    }
}

# Calculate optimal parallel configuration
try {
    $PhysicalCores = (Get-CimInstance -ClassName Win32_Processor).NumberOfCores
} catch {
    $PhysicalCores = 4
    Write-Host "Couldn't determine physical cores, assuming 4." -ForegroundColor Yellow
}

$LogicalCores = [Environment]::ProcessorCount
$OptimalJobs = [Math]::Max(2, [Math]::Min($LogicalCores, $PhysicalCores * 2))

# Apply custom job count if specified
if ($CustomJobs -gt 0) {
    $OptimalJobs = $CustomJobs
}

# Set build type based on parameters
$BuildType = if ($Debug) { "Debug" } else { "Release" }
$UseCuda = if ($Cuda) { "ON" } else { "OFF" }

Write-Host "=== Parallel Build Configuration ===" -ForegroundColor Cyan
Write-Host "Physical CPU cores: $PhysicalCores"
Write-Host "Logical CPU cores: $LogicalCores"
Write-Host "Parallel jobs: $OptimalJobs"
Write-Host "Build type: $BuildType"
Write-Host "CUDA support: $UseCuda"

# Add Rust to PATH if it exists
if (Test-Path -Path "$env:USERPROFILE\.cargo\bin") {
    $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
}

# Check for required tools
$missingTools = @()
foreach ($tool in @("cmake", "ninja", "cargo")) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        $missingTools += $tool
    }
}

if ($missingTools.Count -gt 0) {
    Write-Host "Required tools are missing: $($missingTools -join ', ')" -ForegroundColor Red
    Write-Host "Please install them manually or run the setup script as administrator." -ForegroundColor Yellow
    Write-Host "1. CMake: https://cmake.org/download/" 
    Write-Host "2. Ninja: https://github.com/ninja-build/ninja/releases"
    Write-Host "3. Rust:  https://rustup.rs/"
    exit 1
}

# First, build libraries
Write-Host "Building Rust libraries..." -ForegroundColor Cyan
$StartTime = Get-Date

# Build CMake environment
Write-Host "Setting up CMake build environment..." -ForegroundColor Green
$BuildDir = "build\cmake-$BuildType"
New-Item -Path $BuildDir -ItemType Directory -Force | Out-Null
Push-Location $BuildDir

# Configure with CMake
Write-Host "Configuring CMake build with Ninja..."
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=$BuildType -DTABBY_USE_CUDA=$UseCuda -DTABBY_PARALLEL_LEVEL=$OptimalJobs

# Build with Ninja
Write-Host "Building with Ninja -j$OptimalJobs..."
cmake --build . -- -j $OptimalJobs

Pop-Location

$EndTime = Get-Date
$ElapsedTime = $EndTime - $StartTime

Write-Host "Build completed in $($ElapsedTime.TotalSeconds) seconds" -ForegroundColor Green

# Print a summary of what was built
Write-Host ""
Write-Host "=== Build Summary ===" -ForegroundColor Cyan
Write-Host "  Build Type: $BuildType"
Write-Host "  CUDA support: $UseCuda"
Write-Host "  Parallel jobs: $OptimalJobs"

# List built binaries
if (Test-Path -Path "target\$BuildType") {
    Write-Host ""
    Write-Host "=== Built Binaries ===" -ForegroundColor Cyan
    Get-ChildItem -Path "target\$BuildType" -File | Where-Object { $_.Extension -eq ".exe" } | ForEach-Object {
        Write-Host "  $($_.Name)"
    }
}

# Check build output size
$OutputSize = 0
if (Test-Path -Path "target\$BuildType") {
    $OutputSize = (Get-ChildItem -Path "target\$BuildType" -Recurse | Measure-Object -Property Length -Sum).Sum
    Write-Host "Total output size: $([Math]::Round($OutputSize / 1MB, 2)) MB"
}

Write-Host ""
Write-Host "Build completed successfully!" -ForegroundColor Green
