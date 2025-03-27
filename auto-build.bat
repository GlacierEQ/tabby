@echo off
setlocal enabledelayedexpansion
title Tabby Auto Builder

REM Colors for console output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "RESET=[0m"

echo %CYAN%========================================%RESET%
echo %CYAN%    TABBY AUTOMATED BUILD SYSTEM       %RESET%
echo %CYAN%========================================%RESET%
echo.

REM Check if directories exist
if not exist automation mkdir automation

REM Check if the auto-run.ps1 script exists
if not exist automation\auto-run.ps1 (
    echo %YELLOW%Auto-run script not found. Setting up automation...%RESET%
    
    REM Create automation directory if it doesn't exist
    if not exist automation mkdir automation
    
    REM Copy existing scripts if available or create placeholder
    if exist scripts\build_cmake.ps1 (
        powershell -Command "Copy-Item scripts\build_cmake.ps1 automation\"
        echo %GREEN%Copied build script to automation directory%RESET%
    )
    
    echo %RED%Please run this script again after completing setup%RESET%
    pause
    exit /b 1
)

REM Process command line arguments
set "action=auto"
set "clean="
set "run="
set "install="
set "ci="

:parse_args
if "%1"=="" goto continue_after_args

if /i "%1"=="--help" goto show_help
if /i "%1"=="release" set "action=release" & goto next_arg
if /i "%1"=="debug" set "action=debug" & goto next_arg
if /i "%1"=="cuda" set "action=cuda" & goto next_arg
if /i "%1"=="rocm" set "action=rocm" & goto next_arg
if /i "%1"=="all" set "action=all" & goto next_arg
if /i "%1"=="clean" set "action=clean" & goto next_arg
if /i "%1"=="verify" set "action=verify" & goto next_arg
if /i "%1"=="run" set "action=run" & goto next_arg
if /i "%1"=="--clean" set "clean=-Clean" & goto next_arg
if /i "%1"=="--run" set "run=-Run" & goto next_arg
if /i "%1"=="--install" set "install=-Install" & goto next_arg
if /i "%1"=="--ci" set "ci=-CI" & goto next_arg

echo %RED%Unknown argument: %1%RESET%
goto show_help

:next_arg
shift
goto parse_args

:continue_after_args
REM Execute the PowerShell script with parsed arguments
powershell -ExecutionPolicy Bypass -File "automation\auto-run.ps1" %action% %clean% %run% %install% %ci%
if %errorlevel% neq 0 (
    echo %RED%Build failed with error code: %errorlevel%%RESET%
    pause
    exit /b %errorlevel%
) else (
    echo %GREEN%Build completed successfully!%RESET%
    if "%run%"=="-Run" (
        echo %GREEN%Tabby is now running...%RESET%
    )
    exit /b 0
)

:show_help
echo.
echo Usage: auto-build.bat [ACTION] [OPTIONS]
echo.
echo Actions:
echo   release     Build release version
echo   debug       Build debug version
echo   cuda        Build CUDA version
echo   rocm        Build ROCm version
echo   all         Build all configurations
echo   clean       Clean build directories
echo   verify      Verify environment
echo   run         Run Tabby without building
echo.
echo Options:
echo   --clean     Clean before building
echo   --run       Run after building
echo   --install   Install dependencies
echo   --ci        Run in CI mode (non-interactive)
echo   --help      Show this help message
echo.
echo Examples:
echo   auto-build.bat               Auto-detect and build optimal configuration
echo   auto-build.bat release --run Build release version and run
echo   auto-build.bat all --clean   Build all configurations after cleaning
echo.
exit /b 0
