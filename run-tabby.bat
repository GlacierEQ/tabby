@echo off
setlocal enabledelayedexpansion
title Tabby Runner

REM Colors for console output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "RESET=[0m"

echo %CYAN%==================================%RESET%
echo %CYAN%          TABBY RUNNER           %RESET%
echo %CYAN%==================================%RESET%
echo.

REM Default model and device
set "MODEL=TabbyML/StarCoder-1B"
set "DEVICE=cpu"
set "PORT=8080"
set "ADDITIONAL_ARGS="

REM Parse command line arguments
if not "%1"=="" (
    set "DEVICE=%1"
)
if not "%2"=="" (
    set "MODEL=%2"
)
if not "%3"=="" (
    set "PORT=%3"
)
if not "%4"=="" (
    set "ADDITIONAL_ARGS=%4"
)

REM Check if tabby executable exists
if not exist target\release\tabby.exe (
    echo %RED%Tabby executable not found!%RESET%
    echo.
    echo Would you like to:
    echo  1. Build Tabby now
    echo  2. Exit
    
    set /p choice="Enter your choice (1-2): "
    
    if "!choice!"=="1" (
        echo %CYAN%Building Tabby...%RESET%
        call WindowsBuild.bat
        if !errorlevel! neq 0 (
            echo %RED%Build failed! Cannot continue.%RESET%
            pause
            exit /b 1
        )
    ) else (
        echo %YELLOW%Exiting without running.%RESET%
        exit /b 1
    )
)

echo %GREEN%Starting Tabby with the following configuration:%RESET%
echo  - Model: %MODEL%
echo  - Device: %DEVICE%
echo  - Port: %PORT%
if not "%ADDITIONAL_ARGS%"=="" (
    echo  - Additional arguments: %ADDITIONAL_ARGS%
)
echo.

REM Construct command based on device
if "%DEVICE%"=="cpu" (
    echo %CYAN%Running on CPU...%RESET%
    target\release\tabby.exe serve --model %MODEL% --port %PORT% %ADDITIONAL_ARGS%
) else if "%DEVICE%"=="cuda" (
    echo %CYAN%Running with CUDA (NVIDIA GPU)...%RESET%
    target\release\tabby.exe serve --model %MODEL% --device cuda --port %PORT% %ADDITIONAL_ARGS%
) else if "%DEVICE%"=="rocm" (
    echo %CYAN%Running with ROCm (AMD GPU)...%RESET%
    target\release\tabby.exe serve --model %MODEL% --device rocm --port %PORT% %ADDITIONAL_ARGS%
) else if "%DEVICE%"=="metal" (
    echo %CYAN%Running with Metal (Apple Silicon)...%RESET%
    target\release\tabby.exe serve --model %MODEL% --device metal --port %PORT% %ADDITIONAL_ARGS%
) else if "%DEVICE%"=="vulkan" (
    echo %CYAN%Running with Vulkan...%RESET%
    target\release\tabby.exe serve --model %MODEL% --device vulkan --port %PORT% %ADDITIONAL_ARGS%
) else (
    echo %RED%Unknown device: %DEVICE%%RESET%
    echo %YELLOW%Falling back to CPU...%RESET%
    target\release\tabby.exe serve --model %MODEL% --port %PORT% %ADDITIONAL_ARGS%
)

echo.
echo %RED%Tabby has stopped running.%RESET%
pause
endlocal
