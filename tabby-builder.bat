@echo off
setlocal enabledelayedexpansion
title Tabby Unified Builder

REM Colors for console output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "MAGENTA=[35m"
set "BLUE=[34m"
set "RESET=[0m"

echo %CYAN%========================================%RESET%
echo %CYAN%      TABBY UNIFIED BUILD SYSTEM       %RESET%
echo %CYAN%========================================%RESET%
echo.

if "%1"=="--help" goto show_help
if "%1"=="--auto" goto auto_build
if "%1"=="--ci" goto ci_build
if not "%1"=="" goto direct_command

:show_menu
call :detect_gpu
cls
echo %CYAN%Tabby Builder - Main Menu%RESET%
echo.
echo %CYAN%Standard Builds:%RESET%
echo  %GREEN%1.%RESET% Auto Build (Optimized for your system: !RECOMMENDED_BUILD!)
echo  %GREEN%2.%RESET% Release Build (CPU)
echo  %GREEN%3.%RESET% Debug Build (CPU)
if "%NVIDIA_DETECTED%"=="1" echo  %GREEN%4.%RESET% CUDA Build (NVIDIA GPU) %YELLOW%[Recommended for your system]%RESET%
if not "%NVIDIA_DETECTED%"=="1" echo  %GREEN%4.%RESET% CUDA Build (NVIDIA GPU)
if "%AMD_DETECTED%"=="1" echo  %GREEN%5.%RESET% ROCm Build (AMD GPU) %YELLOW%[Recommended for your system]%RESET%
if not "%AMD_DETECTED%"=="1" echo  %GREEN%5.%RESET% ROCm Build (AMD GPU)
echo  %GREEN%6.%RESET% Build All Configurations
echo.
echo %CYAN%Advanced Options:%RESET%
echo  %BLUE%7.%RESET% Clean Build (Full Rebuild)
echo  %BLUE%8.%RESET% Auto-Evolution (Self-optimizing build)
echo  %BLUE%9.%RESET% Verify/Setup Tools
echo  %BLUE%A.%RESET% Schedule Builds
echo.
echo  %RED%0.%RESET% Exit
echo.

set /p choice="Enter your choice (0-9, A): "
echo.

if "%choice%"=="0" exit /b 0
if "%choice%"=="1" goto auto_build
if "%choice%"=="2" goto release_build
if "%choice%"=="3" goto debug_build
if "%choice%"=="4" goto cuda_build
if "%choice%"=="5" goto rocm_build
if "%choice%"=="6" goto build_all
if "%choice%"=="7" goto clean_build
if "%choice%"=="8" goto evolution_build
if "%choice%"=="9" goto verify_tools
if /i "%choice%"=="A" goto schedule_builds

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto show_menu

:detect_gpu
REM Auto-detect GPUs for menu highlighting
set "NVIDIA_DETECTED=0"
set "AMD_DETECTED=0"
set "RECOMMENDED_BUILD=Release"

wmic path win32_VideoController get name | findstr /i "NVIDIA" >nul 2>&1
if %errorlevel% equ 0 (
    set "NVIDIA_DETECTED=1"
    set "RECOMMENDED_BUILD=CUDA"
)

wmic path win32_VideoController get name | findstr /i "AMD Radeon" >nul 2>&1
if %errorlevel% equ 0 (
    set "AMD_DETECTED=1"
    set "RECOMMENDED_BUILD=ROCm"
)

goto :eof

:direct_command
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*
goto end

:auto_build
echo %GREEN%Starting Auto Build (optimized for your hardware)...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target auto -Run
goto end_with_pause

:release_build
echo %GREEN%Starting Release Build...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target release -Run
goto end_with_pause

:debug_build
echo %GREEN%Starting Debug Build...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target debug -Run
goto end_with_pause

:cuda_build
echo %GREEN%Starting CUDA Build...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target cuda -Run
goto end_with_pause

:rocm_build
echo %GREEN%Starting ROCm Build...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target rocm -Run
goto end_with_pause

:build_all
echo %GREEN%Building all configurations...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target all
goto end_with_pause

:clean_build
echo %YELLOW%Performing clean build...%RESET%
echo This will delete all build artifacts and rebuild from scratch.
set /p confirm="Are you sure? (y/n): "
if /i not "%confirm%"=="y" goto show_menu

echo %YELLOW%Cleaning build directories...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target clean

echo %GREEN%Starting fresh build...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target auto -Clean -Run
goto end_with_pause

:evolution_build
echo %MAGENTA%Starting build system evolution...%RESET%
echo This will analyze previous builds and optimize the build process.
powershell -ExecutionPolicy Bypass -File "%~dp0build-master.ps1" -Target evolve
goto end_with_pause

:verify_tools
echo %CYAN%Verifying build tools...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Verify -Install
goto end_with_pause

:schedule_builds
cls
echo %CYAN%Schedule automated builds:%RESET%
echo.
echo 1. Daily build at 3:00 AM
echo 2. Weekly build (Sunday at 1:00 AM)
echo 3. Custom schedule
echo 0. Back to main menu
echo.
set /p sched_choice="Enter your choice (0-3): "

if "%sched_choice%"=="0" goto show_menu
if "%sched_choice%"=="1" powershell -ExecutionPolicy Bypass -File "%~dp0scheduled-builds.ps1" -Action create -Schedule daily -Time "03:00" -BuildType auto
if "%sched_choice%"=="2" powershell -ExecutionPolicy Bypass -File "%~dp0scheduled-builds.ps1" -Action create -Schedule weekly -Time "01:00" -BuildType all
if "%sched_choice%"=="3" goto custom_schedule
goto end_with_pause

:custom_schedule
set /p cust_time="Enter time (HH:MM): "
set /p cust_type="Enter build type (release/debug/cuda/all): "
set /p cust_clean="Clean build? (y/n): "

set clean_arg=
if /i "%cust_clean%"=="y" set clean_arg=-Clean

powershell -ExecutionPolicy Bypass -File "%~dp0scheduled-builds.ps1" -Action create -Schedule daily -Time "%cust_time%" -BuildType %cust_type% %clean_arg%
goto end_with_pause

:ci_build
echo %CYAN%Running CI build...%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target auto -Clean -CI
goto end

:show_help
echo Tabby Unified Builder
echo.
echo Usage:
echo   tabby-builder [options]
echo.
echo Options:
echo   --auto        Auto-detect best build configuration
echo   --clean       Clean build directories before building
echo   --ci          Run in CI mode (non-interactive)
echo   --debug       Build debug configuration
echo   --cuda        Build with CUDA support
echo   --rocm        Build with ROCm support
echo   --verify      Verify build environment
echo   --help        Show this help message
echo.
echo With no options, shows an interactive menu.
goto end

:end_with_pause
echo.
pause
goto end

:end
