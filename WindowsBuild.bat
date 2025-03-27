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
