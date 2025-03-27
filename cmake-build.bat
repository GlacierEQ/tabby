@echo off
setlocal enabledelayedexpansion
title Tabby CMake Automation

REM Colors for console output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "MAGENTA=[35m"
set "RESET=[0m"

echo %CYAN%========================================%RESET%
echo %CYAN%      TABBY CMAKE AUTOMATION SYSTEM     %RESET%
echo %CYAN%========================================%RESET%
echo.

REM Parse arguments
set "build_type=auto"
set "clean="
set "parallel="
set "jobs=0"
set "verbose="
set "install="
set "run="
set "export="
set "export_dir="
set "no_interactive="
set "generator=Ninja"

:parse_args
if "%1"=="" goto continue_parsing
if /i "%1"=="--type" (
    set "build_type=%2"
    shift
    goto next_arg
)
if /i "%1"=="--clean" (
    set "clean=-Clean"
    goto next_arg
)
if /i "%1"=="--parallel" (
    set "parallel=-Parallel"
    goto next_arg
)
if /i "%1"=="--jobs" (
    set "jobs=%2"
    shift
    goto next_arg
)
if /i "%1"=="--verbose" (
    set "verbose=-Verbose"
    goto next_arg
)
if /i "%1"=="--install" (
    set "install=-Install"
    goto next_arg
)
if /i "%1"=="--run" (
    set "run=-Run"
    goto next_arg
)
if /i "%1"=="--export" (
    set "export=-Export"
    if "%2"=="" goto next_arg
    if "%2:~0,1%"=="-" goto next_arg
    set "export_dir=%2"
    shift
    goto next_arg
)
if /i "%1"=="--no-interactive" (
    set "no_interactive=-NoInteractive"
    goto next_arg
)
if /i "%1"=="--generator" (
    set "generator=%2"
    shift
    goto next_arg
)
if /i "%1"=="release" set "build_type=release" & goto next_arg
if /i "%1"=="debug" set "build_type=debug" & goto next_arg
if /i "%1"=="cuda" set "build_type=cuda" & goto next_arg
if /i "%1"=="rocm" set "build_type=rocm" & goto next_arg
if /i "%1"=="metal" set "build_type=metal" & goto next_arg
if /i "%1"=="vulkan" set "build_type=vulkan" & goto next_arg
if /i "%1"=="clean" set "build_type=clean" & goto next_arg
if /i "%1"=="verify" set "build_type=verify" & goto next_arg
if /i "%1"=="--help" goto show_help

echo %RED%Unknown argument: %1%RESET%
goto show_help

:next_arg
shift
goto parse_args

:continue_parsing

REM Execute the PowerShell script with parsed arguments
set "export_arg="
if defined export_dir set "export_arg=-ExportDir %export_dir%"

powershell -ExecutionPolicy Bypass -File "%~dp0cmake-build.ps1" -BuildType %build_type% %clean% %parallel% -Jobs %jobs% %verbose% %install% %run% %export% %export_arg% %no_interactive% -Generator "%generator%"

if %errorlevel% neq 0 (
    echo %RED%Build failed with error code: %errorlevel%%RESET%
    exit /b %errorlevel%
) else (
    echo %GREEN%Build completed successfully!%RESET%
    exit /b 0
)

:show_help
echo.
echo Usage: cmake-build.bat [build_type] [options]
echo.
echo Build Types:
echo   release    Standard release build
echo   debug      Debug build
echo   cuda       Build with CUDA support for NVIDIA GPUs
echo   rocm       Build with ROCm support for AMD GPUs
echo   metal      Build with Metal support for Apple Silicon
echo   vulkan     Build with Vulkan support
echo   clean      Clean build directories
echo   verify     Verify build environment
echo   auto       Auto-detect best build type (default)
echo.
echo Options:
echo   --clean             Clean before building
echo   --parallel          Build in parallel
echo   --jobs NUMBER       Number of parallel jobs (default: auto)
echo   --verbose           Enable verbose output
echo   --install           Install missing tools if needed
echo   --run               Run after building
echo   --export [DIR]      Export build artifacts to directory
echo   --no-interactive    Disable interactive features
echo   --generator "GEN"   Specify CMake generator (default: "Ninja")
echo   --help              Show this help message
echo.
echo Examples:
echo   cmake-build.bat cuda --clean --run    Build CUDA version and run
echo   cmake-build.bat debug --jobs 4        Build debug with 4 parallel jobs
echo   cmake-build.bat clean                 Clean all build directories
echo.
exit /b 0
