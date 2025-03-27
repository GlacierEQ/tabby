@echo off
setlocal enabledelayedexpansion
title Ninja Team Builder for Tabby

REM Colors for console output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "MAGENTA=[35m"
set "RESET=[0m"

echo %CYAN%========================================%RESET%
echo %CYAN%      NINJA TEAM BUILD SYSTEM          %RESET%
echo %CYAN%========================================%RESET%
echo.

REM Parse arguments
set "build_mode=all"
set "team_size=0"
set "clean="
set "run="
set "verbose="
set "progress="

:parse_args
if "%1"=="" goto continue_parsing
if /i "%1"=="--help" goto show_help
if /i "%1"=="--team" (
    set "team_size=%2"
    shift
    goto next_arg
)
if /i "%1"=="--clean" (
    set "clean=-Clean"
    goto next_arg
)
if /i "%1"=="--run" (
    set "run=-Run"
    goto next_arg
)
if /i "%1"=="--verbose" (
    set "verbose=-Verbose"
    goto next_arg
)
if /i "%1"=="--progress" (
    set "progress=-ShowProgress"
    goto next_arg
)
if /i "%1"=="release" set "build_mode=release" & goto next_arg
if /i "%1"=="debug" set "build_mode=debug" & goto next_arg
if /i "%1"=="cuda" set "build_mode=cuda" & goto next_arg
if /i "%1"=="all" set "build_mode=all" & goto next_arg
if /i "%1"=="full" set "build_mode=full" & goto next_arg
if /i "%1"=="minimum" set "build_mode=minimum" & goto next_arg

echo %RED%Unknown argument: %1%RESET%
goto show_help

:next_arg
shift
goto parse_args

:continue_parsing

REM Execute the PowerShell script with parsed arguments
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\run-ninja-team.ps1" -BuildMode %build_mode% -TeamSize %team_size% %clean% %run% %verbose% %progress%

if %errorlevel% neq 0 (
    echo %RED%Build failed with error code: %errorlevel%%RESET%
    exit /b %errorlevel%
) else (
    echo %GREEN%All builds completed successfully!%RESET%
    exit /b 0
)

:show_help
echo.
echo Usage: ninja-team.bat [mode] [options]
echo.
echo Modes:
echo   release    Build release version only
echo   debug      Build debug version only
echo   cuda       Build CUDA version only
echo   all        Build all main configurations (default)
echo   full       Build all configurations (including experimental ones)
echo   minimum    Build minimum required configuration
echo.
echo Options:
echo   --team N           Number of ninja processes to run in parallel (default: auto)
echo   --clean            Clean build directories before building
echo   --run              Run Tabby after successful build
echo   --verbose          Enable verbose output from ninja
echo   --progress         Show progress bars during build
echo   --help             Show this help message
echo.
echo Examples:
echo   ninja-team.bat                Build all configurations with auto team size
echo   ninja-team.bat release --run   Build release version and run when done
echo   ninja-team.bat --team 4       Build using exactly 4 ninja processes
echo   ninja-team.bat cuda --clean   Clean and rebuild CUDA version
echo.
exit /b 0
