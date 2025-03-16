# filepath: C:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\scripts\make.ps1
# PowerShell script to mimic make on Windows
param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$targets
)

foreach ($target in $targets) {
    switch ($target) {
        "cmake-verify" {
            Write-Host "Running cmake-verify target..." -ForegroundColor Cyan
            . $PSScriptRoot\build_cmake.ps1 --verify
        }
        "cmake-build" {
            Write-Host "Running cmake-build target..." -ForegroundColor Cyan
            . $PSScriptRoot\build_cmake.ps1
        }
        "cmake-build-parallel" {
            Write-Host "Running cmake-build-parallel target..." -ForegroundColor Cyan
            . $PSScriptRoot\pwsh_parallel_build.ps1
        }
        "cmake-build-cuda" {
            Write-Host "Running cmake-build-cuda target..." -ForegroundColor Cyan
            . $PSScriptRoot\build_cmake.ps1 --cuda
        }
        "cmake-clean" {
            Write-Host "Cleaning cmake build directories..." -ForegroundColor Cyan
            if (Test-Path "..\build\cmake-*") {
                Remove-Item -Recurse -Force "..\build\cmake-*"
            }
        }
        default {
            Write-Host "Target '$target' not supported in Windows PowerShell make wrapper." -ForegroundColor Yellow
        }
    }
}

if (-not $targets) {
    Write-Host "Available targets:" -ForegroundColor Cyan
    Write-Host "  cmake-verify         - Verify CMake and Ninja setup"
    Write-Host "  cmake-build          - Build using CMake and Ninja"
    Write-Host "  cmake-build-parallel - Build with optimal parallelism"
    Write-Host "  cmake-build-cuda     - Build with CUDA support"
    Write-Host "  cmake-clean          - Clean CMake build directories"
}
