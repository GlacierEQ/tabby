@echo off
REM Windows make-like wrapper for Tabby

IF "%1"=="" GOTO help

IF "%1"=="cmake-verify" (
    echo Verifying CMake and Ninja installation...
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\verify_tools.ps1"
    GOTO end
)

IF "%1"=="cmake-build" (
    echo Building with CMake and Ninja...
    CALL "%~dp0WindowsBuild.bat"
    GOTO end
)

IF "%1"=="cmake-build-debug" (
    echo Building debug version with CMake and Ninja...
    CALL "%~dp0WindowsDebugBuild.bat"
    GOTO end
)

IF "%1"=="cmake-build-cuda" (
    echo Building with CUDA support...
    CALL "%~dp0WindowsCudaBuild.bat"
    GOTO end
)

IF "%1"=="cmake-build-parallel" (
    echo Building with parallel optimization...
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\pwsh_parallel_build.ps1"
    GOTO end
)

IF "%1"=="cmake-clean" (
    echo Cleaning CMake build directories...
    IF EXIST build\cmake-* (
        rd /s /q build\cmake-*
        echo Cleaned CMake build directories
    ) ELSE (
        echo No CMake build directories found
    )
    GOTO end
)

IF "%1"=="install-tools" (
    echo Installing required tools...
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-ninja.ps1"
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-cmake.ps1"
    GOTO end
)

IF "%1"=="auto" (
    echo Launching auto-build system...
    CALL "%~dp0auto-build.bat" %2
    GOTO end
)

:help
echo Tabby Windows Build System
echo.
echo Available commands:
echo   make install-tools       - Install CMake and Ninja
echo   make cmake-verify        - Verify CMake and Ninja setup
echo   make cmake-build         - Build with CMake and Ninja
echo   make cmake-build-debug   - Build debug version
echo   make cmake-build-cuda    - Build with CUDA support
echo   make cmake-build-parallel - Build with optimal parallelism
echo   make cmake-clean         - Clean CMake build directories
echo   make auto [config]       - Launch auto-build system (configs: all, release, debug, cuda)
echo.
echo Alternative direct batch files:
echo   auto-build.bat           - Interactive build menu system
echo   WindowsBuild.bat         - Standard release build
echo   WindowsDebugBuild.bat    - Debug build
echo   WindowsCudaBuild.bat     - CUDA-enabled build

:end
