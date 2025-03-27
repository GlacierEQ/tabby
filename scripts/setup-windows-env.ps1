# Windows environment setup script for Tabby development

Write-Host "====== Tabby Windows Development Environment Setup ======" -ForegroundColor Cyan

# Function to check if a command exists
function Test-Command {
    param (
        [string]$Name
    )
    return (Get-Command $Name -ErrorAction SilentlyContinue)
}

# Function to add directory to PATH (session only)
function Add-ToSessionPath {
    param (
        [string]$PathToAdd
    )
    
    if (-not ($env:PATH -like "*$PathToAdd*")) {
        $env:PATH = "$PathToAdd;$env:PATH"
        Write-Host "Added $PathToAdd to session PATH" -ForegroundColor Green
    }
}

# Function to verify CMake installation is working properly
function Test-CMake {
    Write-Host "Verifying CMake installation..." -ForegroundColor Cyan
    
    try {
        $cmakeVersion = & cmake --version | Select-Object -First 1
        Write-Host "✓ CMake is installed: $cmakeVersion" -ForegroundColor Green
        
        # Create a simple test project to verify CMake works properly
        $testDir = Join-Path $env:TEMP "cmake_test_$(Get-Random)"
        New-Item -ItemType Directory -Path $testDir -Force | Out-Null
        Push-Location $testDir
        
        # Create minimal CMake test files
        @"
cmake_minimum_required(VERSION 3.15)
project(cmake_test)
add_executable(test_app main.cpp)
"@ | Out-File -FilePath "CMakeLists.txt" -Encoding utf8

        @"
#include <iostream>
int main() {
    std::cout << "CMake test successful!" << std::endl;
    return 0;
}
"@ | Out-File -FilePath "main.cpp" -Encoding utf8

        # Create and enter build directory
        New-Item -ItemType Directory -Path "build" -Force | Out-Null
        Set-Location "build"
        
        # Test CMake configuration
        Write-Host "Testing CMake configuration..." -ForegroundColor Cyan
        & cmake .. -G "Ninja"
        if ($LASTEXITCODE -ne 0) {
            Write-Host "✗ CMake configuration failed" -ForegroundColor Red
            Pop-Location
            Remove-Item -Path $testDir -Recurse -Force -ErrorAction SilentlyContinue
            return $false
        }
        
        Write-Host "✓ CMake configuration successful" -ForegroundColor Green
        Pop-Location
        Remove-Item -Path $testDir -Recurse -Force -ErrorAction SilentlyContinue
        return $true
    }
    catch {
        Write-Host "✗ CMake verification failed: $_" -ForegroundColor Red
        return $false
    }
}

# Function to set environment variables for CMake to be found by build scripts
function Set-CMakeEnvironment {
    param (
        [string]$CMakePath
    )
    
    # Set environment variables that Cargo's cmake crate looks for
    $env:CMAKE = Join-Path $CMakePath "cmake.exe"
    $env:CMAKE_PREFIX_PATH = $CMakePath
    $env:CMAKE_GENERATOR = "Ninja"
    
    # These variables are also checked by some build systems
    $env:CMAKE_x86_64_pc_windows_msvc = $env:CMAKE
    $env:CMAKE_PREFIX_PATH_x86_64_pc_windows_msvc = $env:CMAKE_PREFIX_PATH
    $env:CMAKE_GENERATOR_x86_64_pc_windows_msvc = $env:CMAKE_GENERATOR
    
    Write-Host "Set CMake environment variables for build scripts" -ForegroundColor Green
}

# Detect installed tools
$cmakePath = $null
$ninjaPath = $null
$cargoPath = $null

# Check for common tool locations
$possiblePaths = @(
    "C:\Program Files\CMake\bin",
    "C:\Program Files (x86)\CMake\bin",
    "C:\tools\ninja",
    "$env:USERPROFILE\.cargo\bin",
    "C:\Program Files\Git\bin",
    "$env:ChocolateyInstall\bin",
    "$env:USERPROFILE\AppData\Roaming\Python\Python313\Scripts"
)

foreach ($path in $possiblePaths) {
    if (Test-Path -Path $path) {
        if (Test-Path -Path (Join-Path $path "cmake.exe")) {
            $cmakePath = $path
        }
        if (Test-Path -Path (Join-Path $path "ninja.exe")) {
            $ninjaPath = $path
        }
        if (Test-Path -Path (Join-Path $path "cargo.exe")) {
            $cargoPath = $path
        }
    }
}

# Check for Rust in standard location and add to path if found
if (Test-Path -Path "$env:USERPROFILE\.cargo\bin") {
    Add-ToSessionPath "$env:USERPROFILE\.cargo\bin"
    
    if (Test-Path -Path "$env:USERPROFILE\.cargo\bin\cargo.exe") {
        $cargoPath = "$env:USERPROFILE\.cargo\bin"
    }
}

# Add found tools to path
if ($cmakePath) {
    Add-ToSessionPath $cmakePath
    Write-Host "Found CMake at: $cmakePath" -ForegroundColor Green
    
    # Set environment variables for CMake
    Set-CMakeEnvironment $cmakePath
    
    # Verify CMake works properly
    if (-not (Test-CMake)) {
        Write-Host "CMake was found but verification failed. Try reinstalling CMake." -ForegroundColor Red
        Write-Host "Download from: https://cmake.org/download/" -ForegroundColor Yellow
    }
} else {
    Write-Host "CMake not found. Please install CMake manually." -ForegroundColor Red
    Write-Host "Download from: https://cmake.org/download/" -ForegroundColor Yellow
    
    # Attempt to install CMake if missing
    $installCMake = Read-Host "Would you like to attempt automatic CMake installation? (y/n)"
    if ($installCMake -eq 'y') {
        try {
            Write-Host "Attempting to install CMake..." -ForegroundColor Yellow
            Invoke-Expression "$PSScriptRoot\install-cmake.ps1"
            
            # Try finding CMake again
            foreach ($path in $possiblePaths) {
                if (Test-Path -Path (Join-Path $path "cmake.exe")) {
                    $cmakePath = $path
                    Add-ToSessionPath $cmakePath
                    Set-CMakeEnvironment $cmakePath
                    Write-Host "Successfully installed CMake at: $cmakePath" -ForegroundColor Green
                    break
                }
            }
            
            if (-not $cmakePath) {
                Write-Host "CMake installation attempted but could not find CMake executable" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Failed to install CMake: $_" -ForegroundColor Red
        }
    }
}

if ($ninjaPath) {
    Add-ToSessionPath $ninjaPath
    Write-Host "Found Ninja at: $ninjaPath" -ForegroundColor Green
} else {
    Write-Host "Ninja not found. Installing via pip..." -ForegroundColor Yellow
    try {
        pip install ninja
        $pythonScripts = "$env:USERPROFILE\AppData\Roaming\Python\Python*\Scripts"
        $ninjaInstallPath = Get-ChildItem $pythonScripts -Filter ninja.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty DirectoryName
        if ($ninjaInstallPath) {
            Add-ToSessionPath $ninjaInstallPath
            Write-Host "Installed Ninja via pip and added to PATH: $ninjaInstallPath" -ForegroundColor Green
        } else {
            Write-Host "Ninja installation via pip failed to find executable." -ForegroundColor Red
            Write-Host "Please install Ninja manually from: https://github.com/ninja-build/ninja/releases" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Failed to install Ninja via pip. Error: $_" -ForegroundColor Red
        Write-Host "Please install Ninja manually from: https://github.com/ninja-build/ninja/releases" -ForegroundColor Yellow
    }
}

if ($cargoPath) {
    Add-ToSessionPath $cargoPath
    Write-Host "Found Cargo at: $cargoPath" -ForegroundColor Green
} else {
    Write-Host "Rust/Cargo not found. Installing..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri https://win.rustup.rs/x86_64 -OutFile rustup-init.exe
        .\rustup-init.exe -y --no-modify-path
        Remove-Item rustup-init.exe
        Add-ToSessionPath "$env:USERPROFILE\.cargo\bin"
        Write-Host "Installed Rust and added to session PATH" -ForegroundColor Green
    } catch {
        Write-Host "Failed to install Rust. Error: $_" -ForegroundColor Red
        Write-Host "Please install Rust manually from: https://rustup.rs/" -ForegroundColor Yellow
    }
}

# Create simplified build script
$buildScriptPath = "c:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\WindowsBuild.bat"
@"
@echo off
echo ===== Tabby Windows Build =====
echo.

REM Add tools to PATH if they exist
if exist "%USERPROFILE%\.cargo\bin" set PATH=%USERPROFILE%\.cargo\bin;%PATH%
if exist "%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts" set PATH=%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts;%PATH%

REM Check for required tools
where ninja >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Ninja not found, please install it first
    echo Try installing with: pip install ninja
    goto :error
)

where cmake >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo CMake not found, please install it first
    echo Download from: https://cmake.org/download/
    goto :error
)

where cargo >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Cargo not found, please install Rust first
    echo Download from: https://rustup.rs/
    goto :error
)

REM Create build directory
mkdir build\cmake-release 2>nul
cd build\cmake-release

REM Configure with CMake
echo Configuring with CMake...
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Release

REM Build with Ninja
echo Building with Ninja...
cmake --build . -- -j%NUMBER_OF_PROCESSORS%

cd ..\..
echo Build completed successfully!
exit /b 0

:error
echo Build failed!
exit /b 1
"@ | Out-File -FilePath $buildScriptPath -Encoding ascii

# Also create a debug version
$debugScriptPath = "c:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\WindowsDebugBuild.bat"
@"
@echo off
echo ===== Tabby Windows Debug Build =====
echo.

REM Add tools to PATH if they exist
if exist "%USERPROFILE%\.cargo\bin" set PATH=%USERPROFILE%\.cargo\bin;%PATH%
if exist "%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts" set PATH=%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts;%PATH%

REM Check for required tools
where ninja >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Ninja not found, please install it first
    echo Try installing with: pip install ninja
    goto :error
)

where cmake >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo CMake not found, please install it first
    echo Download from: https://cmake.org/download/
    goto :error
)

where cargo >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Cargo not found, please install Rust first
    echo Download from: https://rustup.rs/
    goto :error
)

REM Create build directory
mkdir build\cmake-debug 2>nul
cd build\cmake-debug

REM Configure with CMake
echo Configuring with CMake...
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Debug

REM Build with Ninja
echo Building with Ninja...
cmake --build . -- -j%NUMBER_OF_PROCESSORS%

cd ..\..
echo Build completed successfully!
exit /b 0

:error
echo Build failed!
exit /b 1
"@ | Out-File -FilePath $debugScriptPath -Encoding ascii

# Create a CUDA version as well
$cudaScriptPath = "c:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\WindowsCudaBuild.bat"
@"
@echo off
echo ===== Tabby Windows CUDA Build =====
echo.

REM Add tools to PATH if they exist
if exist "%USERPROFILE%\.cargo\bin" set PATH=%USERPROFILE%\.cargo\bin;%PATH%
if exist "%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts" set PATH=%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts;%PATH%

REM Check for required tools
where ninja >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Ninja not found, please install it first
    echo Try installing with: pip install ninja
    goto :error
)

where cmake >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo CMake not found, please install it first
    echo Download from: https://cmake.org/download/
    goto :error
)

where cargo >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Cargo not found, please install Rust first
    echo Download from: https://rustup.rs/
    goto :error
)

REM Create build directory
mkdir build\cmake-cuda 2>nul
cd build\cmake-cuda

REM Configure with CMake
echo Configuring with CMake...
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DTABBY_USE_CUDA=ON

REM Build with Ninja
echo Building with Ninja...
cmake --build . -- -j%NUMBER_OF_PROCESSORS%

cd ..\..
echo Build completed successfully!
exit /b 0

:error
echo Build failed!
exit /b 1
"@ | Out-File -FilePath $cudaScriptPath -Encoding ascii

# Create a direct script to run ninja from Python installation
$directNinjaScript = "c:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\ninja-build.bat"
@"
@echo off
echo ===== Running Ninja Build =====

set PYTHON_SCRIPTS=%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts
set PATH=%PYTHON_SCRIPTS%;%PATH%

if not exist "%PYTHON_SCRIPTS%\ninja.exe" (
    echo Ninja not found in Python scripts directory
    echo Installing ninja via pip...
    pip install ninja
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to install ninja via pip
        exit /b 1
    )
)

echo Using Ninja from: %PYTHON_SCRIPTS%\ninja.exe
"%PYTHON_SCRIPTS%\ninja.exe" %*
"@ | Out-File -FilePath $directNinjaScript -Encoding ascii

# Create a direct script to run cmake with debug info
$cmakeDebugScript = "c:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\cmake-debug.bat"
@"
@echo off
echo ===== CMake Diagnostic Wrapper =====
echo Current PATH: %PATH%
echo.
echo Executing: cmake %*
echo.
cmake %*
"@ | Out-File -FilePath $cmakeDebugScript -Encoding ascii

Write-Host ""
Write-Host "====== Setup Complete ======" -ForegroundColor Cyan

Write-Host ""
Write-Host "Simple batch files have been created for building Tabby:" -ForegroundColor Green
Write-Host "- WindowsBuild.bat         - Standard release build" -ForegroundColor Yellow
Write-Host "- WindowsDebugBuild.bat    - Debug build" -ForegroundColor Yellow
Write-Host "- WindowsCudaBuild.bat     - CUDA-enabled build" -ForegroundColor Yellow
Write-Host "- ninja-build.bat          - Direct Ninja wrapper using Python installation" -ForegroundColor Yellow
Write-Host "- cmake-debug.bat          - CMake diagnostic wrapper" -ForegroundColor Yellow
Write-Host ""
Write-Host "To install the required tools manually:" -ForegroundColor Cyan
Write-Host "1. CMake: https://cmake.org/download/" 
Write-Host "2. Ninja: pip install ninja"
Write-Host "3. Rust:  https://rustup.rs/"
Write-Host ""
Write-Host "After installing, you may need to restart your PowerShell session" -ForegroundColor Yellow

# Check if required tools are available in current session
if (Test-Command "cmake" -and Test-Command "ninja" -and Test-Command "cargo") {
    Write-Host "All required tools are now available in this session!" -ForegroundColor Green
} else {
    Write-Host "Some tools are still missing in the current session. Checking which ones:" -ForegroundColor Red
    
    if (-not (Test-Command "cmake")) {
        Write-Host "  - cmake is missing" -ForegroundColor Red
    }
    if (-not (Test-Command "ninja")) {
        Write-Host "  - ninja is missing" -ForegroundColor Red
    }
    if (-not (Test-Command "cargo")) {
        Write-Host "  - cargo is missing" -ForegroundColor Red
    }
    
    Write-Host "Please install missing tools and restart your PowerShell session." -ForegroundColor Red
}

# Show CMake environment variables for debugging
if ($cmakePath) {
    Write-Host ""
    Write-Host "CMake Environment Variables (for Cargo builds):" -ForegroundColor Cyan
    Write-Host "CMAKE = $env:CMAKE"
    Write-Host "CMAKE_PREFIX_PATH = $env:CMAKE_PREFIX_PATH"
    Write-Host "CMAKE_GENERATOR = $env:CMAKE_GENERATOR"
    Write-Host ""
    Write-Host "To build with these settings permanently, you may add these environment variables to your system" -ForegroundColor Yellow
}
