@echo off
setlocal enabledelayedexpansion
title Tabby Build Automation Manager

REM Colors for console output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "RESET=[0m"

echo %CYAN%========================================%RESET%
echo %CYAN%    TABBY BUILD AUTOMATION MANAGER     %RESET%
echo %CYAN%========================================%RESET%
echo.

REM Check for command line arguments
if "%1"=="run" goto run_build
if "%1"=="schedule" goto schedule_build

:main_menu
cls
echo Choose an automation option:
echo.
echo %CYAN%1. Run Builds%RESET%
echo %CYAN%2. Schedule Builds%RESET%
echo %CYAN%3. Build Status%RESET%
echo %CYAN%4. Clean All Builds%RESET%
echo %CYAN%5. Build Documentation%RESET%
echo %CYAN%0. Exit%RESET%
echo.
set /p choice="Enter your choice (0-5): "

if "%choice%"=="1" goto run_build_menu
if "%choice%"=="2" goto schedule_build_menu
if "%choice%"=="3" goto build_status
if "%choice%"=="4" goto clean_all
if "%choice%"=="5" goto build_docs
if "%choice%"=="0" exit /b 0

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto main_menu

:run_build_menu
cls
echo %CYAN%Select build type to run:%RESET%
echo.
echo 1. All Builds
echo 2. Release Only
echo 3. Debug Only
echo 4. CUDA Only
echo 5. Parallel Build
echo 0. Back to Main Menu
echo.
set /p build_choice="Enter your choice (0-5): "

if "%build_choice%"=="1" goto run_all_builds
if "%build_choice%"=="2" goto run_release_build
if "%build_choice%"=="3" goto run_debug_build
if "%build_choice%"=="4" goto run_cuda_build
if "%build_choice%"=="5" goto run_parallel_build
if "%build_choice%"=="0" goto main_menu

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto run_build_menu

:run_all_builds
echo %CYAN%Running all builds...%RESET%
call start-all-builds.bat
pause
goto main_menu

:run_release_build
echo %CYAN%Running release build...%RESET%
call start-all-builds.bat --release-only
pause
goto main_menu

:run_debug_build
echo %CYAN%Running debug build...%RESET%
call start-all-builds.bat --debug-only
pause
goto main_menu

:run_cuda_build
echo %CYAN%Running CUDA build...%RESET%
call start-all-builds.bat --cuda-only
pause
goto main_menu

:run_parallel_build
echo %CYAN%Running parallel build...%RESET%
powershell -ExecutionPolicy Bypass -File "scripts\pwsh_parallel_build.ps1"
pause
goto main_menu

:schedule_build_menu
cls
echo %CYAN%Schedule automated builds:%RESET%
echo.
echo 1. Create Daily Build
echo 2. Create Weekly Build
echo 3. Create Monthly Build
echo 4. List Scheduled Builds
echo 5. Remove Scheduled Build
echo 0. Back to Main Menu
echo.
set /p schedule_choice="Enter your choice (0-5): "

if "%schedule_choice%"=="1" goto create_daily
if "%schedule_choice%"=="2" goto create_weekly
if "%schedule_choice%"=="3" goto create_monthly
if "%schedule_choice%"=="4" goto list_scheduled
if "%schedule_choice%"=="5" goto remove_scheduled
if "%schedule_choice%"=="0" goto main_menu

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto schedule_build_menu

:create_daily
cls
echo %CYAN%Create daily build task%RESET%
echo.
set /p build_time="Enter time for daily build (HH:MM): "
set /p build_type="Enter build type (release/debug/cuda/all): "
set /p clean_choice="Clean before build? (y/n): "

set clean_flag=
if /i "%clean_choice%"=="y" set clean_flag=-Clean

powershell -ExecutionPolicy Bypass -File "scheduled-builds.ps1" -Action create -Schedule daily -Time "%build_time%" -BuildType %build_type% %clean_flag%
pause
goto schedule_build_menu

:create_weekly
cls
echo %CYAN%Create weekly build task%RESET%
echo.
set /p build_time="Enter time for weekly build (HH:MM): "
set /p build_type="Enter build type (release/debug/cuda/all): "
set /p clean_choice="Clean before build? (y/n): "

set clean_flag=
if /i "%clean_choice%"=="y" set clean_flag=-Clean

powershell -ExecutionPolicy Bypass -File "scheduled-builds.ps1" -Action create -Schedule weekly -Time "%build_time%" -BuildType %build_type% %clean_flag%
pause
goto schedule_build_menu

:create_monthly
cls
echo %CYAN%Create monthly build task%RESET%
echo.
set /p build_time="Enter time for monthly build (HH:MM): "
set /p build_type="Enter build type (release/debug/cuda/all): "
set /p clean_choice="Clean before build? (y/n): "

set clean_flag=
if /i "%clean_choice%"=="y" set clean_flag=-Clean

powershell -ExecutionPolicy Bypass -File "scheduled-builds.ps1" -Action create -Schedule monthly -Time "%build_time%" -BuildType %build_type% %clean_flag%
pause
goto schedule_build_menu

:list_scheduled
echo %CYAN%Listing scheduled builds...%RESET%
powershell -ExecutionPolicy Bypass -File "scheduled-builds.ps1" -Action list
pause
goto schedule_build_menu

:remove_scheduled
cls
echo %CYAN%Remove scheduled build task%RESET%
echo.
set /p build_type="Enter build type to remove (release/debug/cuda/all): "
powershell -ExecutionPolicy Bypass -File "scheduled-builds.ps1" -Action remove -BuildType %build_type%
pause
goto schedule_build_menu

:build_status
cls
echo %CYAN%Checking build status...%RESET%
echo.
echo Last successful builds:

REM Check release build
if exist target\release\tabby.exe (
    echo - %GREEN%Release:%RESET% Succeeded, binary exists
) else (
    echo - %RED%Release:%RESET% Not built or failed
)

REM Check debug build
if exist target\debug\tabby.exe (
    echo - %GREEN%Debug:%RESET% Succeeded, binary exists
) else (
    echo - %RED%Debug:%RESET% Not built or failed
)

REM Check build logs
echo.
echo %CYAN%Recent build logs:%RESET%
if exist logs (
    dir /b /o-d logs\*.log | findstr "master-build" | findstr /v /c:"master-build-template.log"
) else (
    echo No build logs found
)

pause
goto main_menu

:clean_all
cls
echo %CYAN%Cleaning all builds...%RESET%
echo.
set /p confirm="Are you sure you want to delete all build artifacts? (y/n): "
if /i not "%confirm%"=="y" goto main_menu

echo Removing build directories...
if exist build\cmake-* rd /s /q build\cmake-*
if exist target rd /s /q target
echo %GREEN%All build artifacts have been removed.%RESET%
pause
goto main_menu

:build_docs
cls
echo %CYAN%Building documentation...%RESET%
echo.
if not exist docs mkdir docs
echo Generating API documentation...
cargo doc --all --no-deps --document-private-items
if %errorlevel% neq 0 (
    echo %RED%Documentation build failed!%RESET%
) else (
    echo %GREEN%Documentation built successfully!%RESET%
    echo Documentation available at: %cd%\target\doc\tabby\index.html
)
pause
goto main_menu

:run_build
call start-all-builds.bat %2 %3 %4
exit /b %errorlevel%

:schedule_build
powershell -ExecutionPolicy Bypass -File "scheduled-builds.ps1" %2 %3 %4 %5
exit /b %errorlevel%
