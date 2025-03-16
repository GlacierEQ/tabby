# PowerShell script to verify that CMake and Ninja are correctly configured

Write-Host "=== CMake/Ninja Verification Tool ===" -ForegroundColor Cyan
Write-Host ""

# Check CMake
if (Get-Command "cmake.exe" -ErrorAction SilentlyContinue) {
    $CMakeVersion = & cmake --version | Select-Object -First 1
    Write-Host "✓ CMake is installed: $CMakeVersion" -ForegroundColor Green
} else {
    Write-Host "✗ CMake is not installed. Please install CMake." -ForegroundColor Red
    exit 1
}

# Check Ninja
if (Get-Command "ninja.exe" -ErrorAction SilentlyContinue) {
    $NinjaVersion = & ninja --version
    Write-Host "✓ Ninja is installed: v$NinjaVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Ninja is not installed. Please install Ninja." -ForegroundColor Red
    exit 1
}

# Check for multiprocessing capability
$NumCores = [Environment]::ProcessorCount
Write-Host "✓ This system has $NumCores CPU cores available for parallel builds" -ForegroundColor Green

# Check if we're in a Git repository
try {
    $null = & git rev-parse --is-inside-work-tree
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Running in a Git repository" -ForegroundColor Green
        
        # Check for submodules (especially llama.cpp)
        $submodules = & git submodule status
        if ($submodules -match "llama.cpp") {
            if (Test-Path -Path "crates/llama-cpp-server/llama.cpp") {
                Write-Host "✓ llama.cpp submodule is present" -ForegroundColor Green
            } else {
                Write-Host "✗ llama.cpp submodule directory not found, but it's in .gitmodules" -ForegroundColor Red
                Write-Host "  Run: git submodule update --init --recursive" -ForegroundColor Yellow
            }
        }
    }
} catch {
    Write-Host "? Not running in a Git repository" -ForegroundColor Yellow
}

# Test a minimal CMake configuration
Write-Host ""
Write-Host "=== Testing CMake Configuration ===" -ForegroundColor Cyan

$TestDir = Join-Path $env:TEMP "cmake_ninja_test_$(Get-Random)"
New-Item -ItemType Directory -Path $TestDir -Force | Out-Null
Push-Location $TestDir

@"
cmake_minimum_required(VERSION 3.15)
project(cmake_test)
add_executable(test_app main.cpp)
"@ | Out-File -FilePath "CMakeLists.txt" -Encoding utf8

@"
#include <iostream>
int main() {
    std::cout << "CMake/Ninja test successful!" << std::endl;
    return 0;
}
"@ | Out-File -FilePath "main.cpp" -Encoding utf8

Write-Host "Creating build directory..."
New-Item -ItemType Directory -Path "build" -Force | Out-Null
Set-Location "build"

Write-Host "Configuring CMake with Ninja..."
& cmake .. -G "Ninja"
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ CMake configuration successful" -ForegroundColor Green
} else {
    Write-Host "✗ CMake configuration failed" -ForegroundColor Red
    Pop-Location
    Remove-Item -Path $TestDir -Recurse -Force
    exit 1
}

Write-Host "Building test project..."
& cmake --build .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Build successful" -ForegroundColor Green
    if (Test-Path -Path "test_app.exe") {
        Write-Host "✓ Executable was created" -ForegroundColor Green
    } else {
        Write-Host "✗ Executable was not created" -ForegroundColor Red
    }
} else {
    Write-Host "✗ Build failed" -ForegroundColor Red
    Pop-Location
    Remove-Item -Path $TestDir -Recurse -Force
    exit 1
}

Pop-Location
Remove-Item -Path $TestDir -Recurse -Force

Write-Host ""
Write-Host "=== All checks passed! ===" -ForegroundColor Green
Write-Host "CMake and Ninja are correctly configured for parallel builds."
Write-Host "You can now run 'powershell -File scripts\build_cmake.ps1' to build the project."
