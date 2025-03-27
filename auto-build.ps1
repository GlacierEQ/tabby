# Advanced PowerShell auto-build script for Tabby

# Command line parameters
param(
    [Parameter(Position=0)]
    [ValidateSet("all", "release", "debug", "cuda", "parallel", "clean", "")]
    [string]$BuildType = "",
    
    [switch]$NoPrompt,
    [switch]$NoBanner,
    [int]$ParallelJobs = 0
)

# Function definitions
function Show-Banner {
    $banner = @"
╔════════════════════════════════════╗
║       TABBY AUTO-BUILD SYSTEM      ║
╚════════════════════════════════════╝
"@
    Write-Host $banner -ForegroundColor Cyan
}

function Show-Menu {
    Write-Host "Select build option:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] Build all configurations" -ForegroundColor White
    Write-Host "  [2] Build release version" -ForegroundColor Green
    Write-Host "  [3] Build debug version" -ForegroundColor Blue
    Write-Host "  [4] Build with CUDA support" -ForegroundColor Magenta
    Write-Host "  [5] Build with parallel optimization" -ForegroundColor Cyan
    Write-Host "  [6] Clean all build directories" -ForegroundColor Red
    Write-Host "  [7] Verify environment" -ForegroundColor Yellow
    Write-Host "  [0] Exit" -ForegroundColor Gray
    Write-Host ""
    
    $choice = Read-Host "Enter your choice (0-7)"
    return $choice
}

function Invoke-Task {
    param($Title, $Task)
    
    Write-Host "┌─ $Title " -ForegroundColor Cyan
    Write-Host "│"
    & $Task
    $exitCode = $LASTEXITCODE
    Write-Host "│"
    if ($exitCode -eq 0) {
        Write-Host "└─ Completed Successfully ✓" -ForegroundColor Green
    } else {
        Write-Host "└─ Failed with exit code $exitCode ✗" -ForegroundColor Red
    }
    Write-Host ""
    return $exitCode
}

function Build-Release {
    Write-Host "Building release version..." -ForegroundColor Green
    
    # Ensure directory exists
    $buildDir = "build\cmake-Release"
    if (Test-Path $buildDir) {
        Remove-Item -Path $buildDir -Recurse -Force
    }
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    
    # Build
    Push-Location $buildDir
    cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
    $cores = if ($ParallelJobs -gt 0) { $ParallelJobs } else { [Environment]::ProcessorCount }
    cmake --build . -- -j$cores
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    return $exitCode
}

function Build-Debug {
    Write-Host "Building debug version..." -ForegroundColor Blue
    
    # Ensure directory exists
    $buildDir = "build\cmake-Debug"
    if (Test-Path $buildDir) {
        Remove-Item -Path $buildDir -Recurse -Force
    }
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    
    # Build
    Push-Location $buildDir
    cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Debug
    $cores = if ($ParallelJobs -gt 0) { $ParallelJobs } else { [Environment]::ProcessorCount }
    cmake --build . -- -j$cores
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    return $exitCode
}

function Build-Cuda {
    Write-Host "Building with CUDA support..." -ForegroundColor Magenta
    
    # Ensure directory exists
    $buildDir = "build\cmake-Cuda"
    if (Test-Path $buildDir) {
        Remove-Item -Path $buildDir -Recurse -Force
    }
    New-Item -Path $buildDir -ItemType Directory -Force | Out-Null
    
    # Build
    Push-Location $buildDir
    cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DTABBY_USE_CUDA=ON
    $cores = if ($ParallelJobs -gt 0) { $ParallelJobs } else { [Environment]::ProcessorCount }
    cmake --build . -- -j$cores
    $exitCode = $LASTEXITCODE
    Pop-Location
    
    return $exitCode
}

function Build-Parallel {
    Write-Host "Building with parallel optimization..." -ForegroundColor Cyan
    & "$PSScriptRoot\scripts\pwsh_parallel_build.ps1"
    return $LASTEXITCODE
}

function Clean-All {
    Write-Host "Cleaning all build directories..." -ForegroundColor Red
    if (Test-Path "build\cmake-*") {
        Remove-Item -Path "build\cmake-*" -Recurse -Force
        Write-Host "Cleaned all build directories."
    } else {
        Write-Host "No build directories to clean."
    }
    return 0
}

function Verify-Environment {
    Write-Host "Verifying build environment..." -ForegroundColor Yellow
    & "$PSScriptRoot\scripts\verify_tools.ps1"
    return $LASTEXITCODE
}

function Build-All {
    $exitCode = 0
    $exitCode += Invoke-Task "Clean All Build Directories" { Clean-All }
    $exitCode += Invoke-Task "Build Release Version" { Build-Release }
    $exitCode += Invoke-Task "Build Debug Version" { Build-Debug }
    $exitCode += Invoke-Task "Build CUDA Version" { Build-Cuda }
    return $exitCode
}

# Main execution
if (-not $NoBanner) {
    Show-Banner
}

# Set up build tools path
if (Test-Path -Path "$env:USERPROFILE\.cargo\bin") {
    $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
}

# Check if Python ninja is available
$pythonNinjaPath = "$env:USERPROFILE\AppData\Roaming\Python\Python313\Scripts"
if (Test-Path -Path "$pythonNinjaPath\ninja.exe") {
    $env:PATH = "$pythonNinjaPath;$env:PATH"
}

# Process direct command or show menu
$exitCode = 0
if ($BuildType -ne "" -or $NoPrompt) {
    switch ($BuildType) {
        "all" { $exitCode = Build-All }
        "release" { $exitCode = Invoke-Task "Build Release Version" { Build-Release } }
        "debug" { $exitCode = Invoke-Task "Build Debug Version" { Build-Debug } }
        "cuda" { $exitCode = Invoke-Task "Build CUDA Version" { Build-Cuda } }
        "parallel" { $exitCode = Invoke-Task "Build Parallel Version" { Build-Parallel } }
        "clean" { $exitCode = Invoke-Task "Clean All Build Directories" { Clean-All } }
        default { 
            # Verify environment if no specific action
            $exitCode = Invoke-Task "Verify Build Environment" { Verify-Environment }
        }
    }
} else {
    # Interactive menu
    $choice = Show-Menu
    
    switch ($choice) {
        "1" { $exitCode = Build-All }
        "2" { $exitCode = Invoke-Task "Build Release Version" { Build-Release } }
        "3" { $exitCode = Invoke-Task "Build Debug Version" { Build-Debug } }
        "4" { $exitCode = Invoke-Task "Build CUDA Version" { Build-Cuda } }
        "5" { $exitCode = Invoke-Task "Build Parallel Version" { Build-Parallel } }
        "6" { $exitCode = Invoke-Task "Clean All Build Directories" { Clean-All } }
        "7" { $exitCode = Invoke-Task "Verify Build Environment" { Verify-Environment } }
        "0" { Write-Host "Exiting..."; return }
        default { Write-Host "Invalid choice. Exiting..." -ForegroundColor Red; return 1 }
    }
}

# Final status
if ($exitCode -eq 0) {
    Write-Host "All build tasks completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Some build tasks failed. Please review the output above." -ForegroundColor Red
}

exit $exitCode
