# PowerShell script for building Tabby with CMake and Ninja on Windows

# Default configuration
$BuildType = "Release"
$Generator = "Ninja"
$UseCuda = "OFF"
$VerifyOnly = "OFF"
$Jobs = [Math]::Max(1, [Environment]::ProcessorCount)
$ParallelLevel = $Jobs

# Parse arguments
$args | ForEach-Object {
    if ($_ -eq "--debug") {
        $BuildType = "Debug"
    }
    elseif ($_ -eq "--cuda") {
        $UseCuda = "ON"
    }
    elseif ($_ -eq "--verify") {
        $VerifyOnly = "ON"
    }
    elseif ($_ -match "--jobs=(.*)") {
        $Jobs = $Matches[1]
    }
    elseif ($_ -match "--parallel=(.*)") {
        $ParallelLevel = $Matches[1]
        $Jobs = $ParallelLevel
    }
}

# Add Rust to PATH if it exists
if (Test-Path -Path "$env:USERPROFILE\.cargo\bin") {
    $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
}

# Check if ninja is installed via Python pip
$pythonNinjaPath = "$env:USERPROFILE\AppData\Roaming\Python\Python313\Scripts"
if (Test-Path -Path "$pythonNinjaPath\ninja.exe") {
    $env:PATH = "$pythonNinjaPath;$env:PATH"
    Write-Host "Added Python-installed Ninja to PATH" -ForegroundColor Green
}

# Check if Ninja is installed
if (-not (Get-Command "ninja" -ErrorAction SilentlyContinue)) {
    Write-Error "Ninja build system not found. Please install ninja-build."
    Write-Host "You can install it with: pip install ninja" -ForegroundColor Yellow
    exit 1
}

# Check if CMake is installed
if (-not (Get-Command "cmake" -ErrorAction SilentlyContinue)) {
    Write-Error "CMake not found. Please install cmake."
    Write-Host "Download from: https://cmake.org/download/" -ForegroundColor Yellow
    exit 1
}

# Display system information
Write-Host "=== Build System Information ===" -ForegroundColor Cyan
Write-Host "Operating System: Windows $(([System.Environment]::OSVersion.Version).ToString())"
Write-Host "Architecture: $([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture)"
Write-Host "CPU cores: $Jobs"

# Display Ninja version
$NinjaVersion = & ninja --version
Write-Host "Using Ninja version: $NinjaVersion"

# Display CMake version
$CMakeVersion = & cmake --version | Select-Object -First 1
Write-Host "Using $CMakeVersion"

# Create build directory
$BuildDir = "build\cmake-$BuildType"
New-Item -Path $BuildDir -ItemType Directory -Force | Out-Null
Push-Location $BuildDir

# Configure with CMake
Write-Host "Configuring CMake build with Ninja..."
cmake ..\.. -G $Generator -DCMAKE_BUILD_TYPE=$BuildType -DTABBY_USE_CUDA=$UseCuda -DTABBY_PARALLEL_LEVEL=$ParallelLevel

# If verify-only mode, just run the verification target
if ($VerifyOnly -eq "ON") {
    Write-Host "Verifying CMake and Ninja setup..."
    cmake --build . --target verify_cmake_ninja
    
    # Additional verification: Check if we can find llama.cpp files
    if (Test-Path -Path "..\..\crates\llama-cpp-server\llama.cpp") {
        Write-Host "✓ llama.cpp directory found" -ForegroundColor Green
    } 
    else {
        Write-Host "⚠️ llama.cpp directory not found at expected location" -ForegroundColor Yellow
        Write-Host "  Run: git submodule update --init --recursive" -ForegroundColor Yellow
    }
    
    Pop-Location
    exit 0
}

# Build with Ninja
Write-Host "Building with Ninja -j$Jobs..."
$StartTime = Get-Date
cmake --build . -- -j $Jobs
$EndTime = Get-Date
$ElapsedTime = $EndTime - $StartTime
Write-Host "Build completed in $($ElapsedTime.TotalSeconds) seconds"

# Return to original directory
Pop-Location
Write-Host "Build completed successfully!" -ForegroundColor Green

# Print a summary of what was built
Write-Host ""
Write-Host "=== Build Summary ===" -ForegroundColor Cyan
Write-Host "  Build Type: $BuildType"
Write-Host "  CUDA support: $UseCuda"
Write-Host "  Parallel jobs: $Jobs"

# Check if any Rust binaries were built
if (Test-Path -Path "target\release") {
    Write-Host ""
    Write-Host "=== Built Binaries ===" -ForegroundColor Cyan
    Get-ChildItem -Path "target\release" -File | Where-Object { $_.Extension -eq ".exe" } | ForEach-Object {
        Write-Host "  $($_.Name)"
    }
}
