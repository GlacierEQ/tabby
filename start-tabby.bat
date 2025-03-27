@echo off
setlocal enabledelayedexpansion
title Tabby Startup Manager

REM Colors for console output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "RESET=[0m"

echo %CYAN%==================================%RESET%
echo %CYAN%      TABBY STARTUP MANAGER      %RESET%
echo %CYAN%==================================%RESET%
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%Note: Some features may require administrator privileges%RESET%
    echo.
)

REM Create startup logs directory
if not exist logs mkdir logs

REM Log file with timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "logdate=%dt:~0,8%-%dt:~8,6%"
set "LOGFILE=logs\tabby-startup-%logdate%.log"

REM Check if running with arguments
if not "%1"=="" (
    echo Running in automated mode with argument: %1
    goto process_argument
)

:main_menu
cls
echo %CYAN%Tabby Startup Manager%RESET%
echo.
echo Choose an option:
echo %CYAN%==================================%RESET%
echo  1. %GREEN%Quick Start%RESET% (Setup, Build Release, Run)
echo  2. %GREEN%Setup Environment%RESET% (Install Tools)
echo  3. %GREEN%Build Options%RESET%
echo  4. %GREEN%Run Options%RESET%
echo  5. %GREEN%Clean Build Directories%RESET%
echo  6. %GREEN%Advanced Options%RESET%
echo  0. %YELLOW%Exit%RESET%
echo.

set /p choice="Enter your choice (0-6): "
echo.

if "%choice%"=="1" goto quick_start
if "%choice%"=="2" goto setup_env
if "%choice%"=="3" goto build_menu
if "%choice%"=="4" goto run_menu
if "%choice%"=="5" goto clean_build
if "%choice%"=="6" goto advanced_menu
if "%choice%"=="0" goto end

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto main_menu

:process_argument
if "%1"=="quick-start" goto quick_start
if "%1"=="setup" goto setup_env
if "%1"=="build" goto process_build_arg
if "%1"=="run" goto process_run_arg
if "%1"=="clean" goto clean_build
echo %RED%Invalid argument: %1%RESET%
goto end

:process_build_arg
if "%2"=="release" goto build_release
if "%2"=="debug" goto build_debug
if "%2"=="cuda" goto build_cuda
if "%2"=="parallel" goto build_parallel
goto build_release

:process_run_arg
if "%2"=="cpu" goto run_cpu
if "%2"=="cuda" goto run_cuda
if "%2"=="rocm" goto run_rocm
if "%2"=="metal" goto run_metal
goto run_cpu

:quick_start
echo %CYAN%=== Quick Start ===%RESET%
echo Performing environment setup, building release version, and running...
echo This will be logged to %LOGFILE%

call :setup_env_action >> "%LOGFILE%" 2>&1
if %errorlevel% neq 0 (
    echo %RED%Setup failed! Check %LOGFILE% for details%RESET%
    pause
    goto main_menu
)

call :build_release_action >> "%LOGFILE%" 2>&1
if %errorlevel% neq 0 (
    echo %RED%Build failed! Check %LOGFILE% for details%RESET%
    pause
    goto main_menu
)

echo %GREEN%Setup and build completed successfully!%RESET%
echo %CYAN%Starting Tabby...%RESET%
call :run_cpu_action
goto end

:setup_env
echo %CYAN%=== Setting Up Environment ===%RESET%
call :setup_env_action
echo.
echo %GREEN%Environment setup completed.%RESET%
pause
goto main_menu

:setup_env_action
echo Setting up environment...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\setup-windows-env.ps1"
return %errorlevel%

:build_menu
cls
echo %CYAN%Build Options%RESET%
echo.
echo Choose a build option:
echo %CYAN%==================================%RESET%
echo  1. %GREEN%Build Release Version%RESET%
echo  2. %GREEN%Build Debug Version%RESET%
echo  3. %GREEN%Build with CUDA Support%RESET%
echo  4. %GREEN%Build with Optimal Parallelism%RESET%
echo  5. %GREEN%Build All Configurations%RESET%
echo  0. %YELLOW%Back to Main Menu%RESET%
echo.

set /p build_choice="Enter your choice (0-5): "
echo.

if "%build_choice%"=="1" goto build_release
if "%build_choice%"=="2" goto build_debug
if "%build_choice%"=="3" goto build_cuda
if "%build_choice%"=="4" goto build_parallel
if "%build_choice%"=="5" goto build_all
if "%build_choice%"=="0" goto main_menu

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto build_menu

:build_release
echo %CYAN%=== Building Release Version ===%RESET%
call :build_release_action
pause
goto build_menu

:build_release_action
call "%~dp0WindowsBuild.bat"
return %errorlevel%

:build_debug
echo %CYAN%=== Building Debug Version ===%RESET%
call "%~dp0WindowsDebugBuild.bat"
pause
goto build_menu

:build_cuda
echo %CYAN%=== Building with CUDA Support ===%RESET%
call "%~dp0WindowsCudaBuild.bat"
pause
goto build_menu

:build_parallel
echo %CYAN%=== Building with Optimal Parallelism ===%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\pwsh_parallel_build.ps1"
pause
goto build_menu

:build_all
echo %CYAN%=== Building All Configurations ===%RESET%
call "%~dp0auto-build.bat" all
pause
goto build_menu

:run_menu
cls
echo %CYAN%Run Options%RESET%
echo.
echo Choose a run option:
echo %CYAN%==================================%RESET%
echo  1. %GREEN%Run Tabby (CPU)%RESET%
echo  2. %GREEN%Run Tabby with CUDA (NVIDIA GPU)%RESET%
echo  3. %GREEN%Run Tabby with ROCm (AMD GPU)%RESET%
echo  4. %GREEN%Run Tabby with Metal (Apple Silicon)%RESET%
echo  0. %YELLOW%Back to Main Menu%RESET%
echo.

set /p run_choice="Enter your choice (0-4): "
echo.

if "%run_choice%"=="1" goto run_cpu
if "%run_choice%"=="2" goto run_cuda
if "%run_choice%"=="3" goto run_rocm
if "%run_choice%"=="4" goto run_metal
if "%run_choice%"=="0" goto main_menu

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto run_menu

:run_cpu
echo %CYAN%=== Running Tabby (CPU) ===%RESET%
call :run_cpu_action
goto run_menu

:run_cpu_action
cd "%~dp0"
if exist target\release\tabby.exe (
    echo %GREEN%Running Tabby with CPU...%RESET%
    target\release\tabby.exe serve --model TabbyML/StarCoder-1B
) else (
    echo %RED%Tabby executable not found!%RESET%
    echo You need to build the project first.
    return 1
)
return 0

:run_cuda
echo %CYAN%=== Running Tabby with CUDA (NVIDIA GPU) ===%RESET%
cd "%~dp0"
if exist target\release\tabby.exe (
    echo %GREEN%Running Tabby with CUDA...%RESET%
    target\release\tabby.exe serve --model TabbyML/StarCoder-1B --device cuda
) else (
    echo %RED%Tabby executable not found!%RESET%
    echo You need to build the project first.
)
pause
goto run_menu

:run_rocm
echo %CYAN%=== Running Tabby with ROCm (AMD GPU) ===%RESET%
cd "%~dp0"
if exist target\release\tabby.exe (
    echo %GREEN%Running Tabby with ROCm...%RESET%
    target\release\tabby.exe serve --model TabbyML/StarCoder-1B --device rocm
) else (
    echo %RED%Tabby executable not found!%RESET%
    echo You need to build the project first.
)
pause
goto run_menu

:run_metal
echo %CYAN%=== Running Tabby with Metal (Apple Silicon) ===%RESET%
echo %YELLOW%Note: Metal is only available on Apple Silicon devices.%RESET%
cd "%~dp0"
if exist target\release\tabby.exe (
    echo %GREEN%Running Tabby with Metal...%RESET%
    target\release\tabby.exe serve --model TabbyML/StarCoder-1B --device metal
) else (
    echo %RED%Tabby executable not found!%RESET%
    echo You need to build the project first.
)
pause
goto run_menu

:clean_build
echo %CYAN%=== Cleaning Build Directories ===%RESET%
echo Cleaning CMake build directories...
if exist build\cmake-* (
    rd /s /q build\cmake-*
    echo %GREEN%Build directories cleaned successfully.%RESET%
) else (
    echo %YELLOW%No build directories found.%RESET%
)
echo.
echo Cleaning Rust target directories...
if exist target (
    rd /s /q target
    echo %GREEN%Rust target directories cleaned successfully.%RESET%
) else (
    echo %YELLOW%No Rust target directories found.%RESET%
)
pause
goto main_menu

:advanced_menu
cls
echo %CYAN%Advanced Options%RESET%
echo.
echo Choose an advanced option:
echo %CYAN%==================================%RESET%
echo  1. %GREEN%Create Desktop Shortcut%RESET%
echo  2. %GREEN%Install Tools for All Users%RESET% (requires admin)
echo  3. %GREEN%Verify Development Environment%RESET%
echo  4. %GREEN%Install Git Hooks%RESET%
echo  5. %GREEN%Show Build Logs%RESET%
echo  0. %YELLOW%Back to Main Menu%RESET%
echo.

set /p adv_choice="Enter your choice (0-5): "
echo.

if "%adv_choice%"=="1" goto create_shortcut
if "%adv_choice%"=="2" goto install_tools_admin
if "%adv_choice%"=="3" goto verify_env
if "%adv_choice%"=="4" goto install_git_hooks
if "%adv_choice%"=="5" goto show_logs
if "%adv_choice%"=="0" goto main_menu

echo %RED%Invalid choice. Please try again.%RESET%
timeout /t 2 >nul
goto advanced_menu

:create_shortcut
echo %CYAN%=== Creating Desktop Shortcut ===%RESET%
powershell -ExecutionPolicy Bypass -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([System.Environment]::GetFolderPath('Desktop') + '\Tabby Startup.lnk'); $Shortcut.TargetPath = '%~dpnx0'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.IconLocation = 'powershell.exe,0'; $Shortcut.Save();"
echo %GREEN%Desktop shortcut created successfully.%RESET%
pause
goto advanced_menu

:install_tools_admin
echo %CYAN%=== Installing Tools for All Users ===%RESET%
echo This requires administrator privileges.
echo %YELLOW%Restarting script as administrator...%RESET%
powershell -Command "Start-Process cmd.exe -ArgumentList '/c cd /d %cd% && %~nx0 setup-admin' -Verb RunAs"
goto advanced_menu

:verify_env
echo %CYAN%=== Verifying Development Environment ===%RESET%
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\verify_tools.ps1"
pause
goto advanced_menu

:install_git_hooks
echo %CYAN%=== Installing Git Hooks ===%RESET%
if exist .git\hooks (
    echo Setting up pre-commit hooks...
    powershell -ExecutionPolicy Bypass -Command "Copy-Item -Path '%~dp0scripts\git-hooks\*' -Destination '.git\hooks\' -Force"
    echo %GREEN%Git hooks installed successfully.%RESET%
) else (
    echo %RED%Git repository not found! Please run this from the repository root.%RESET%
)
pause
goto advanced_menu

:show_logs
echo %CYAN%=== Build Logs ===%RESET%
if exist logs (
    dir /b logs\*.log
    echo.
    set /p log_file="Enter log filename to view (or ENTER to cancel): "
    if not "%log_file%"=="" (
        if exist "logs\%log_file%" (
            more "logs\%log_file%"
        ) else (
            echo %RED%Log file not found!%RESET%
        )
    )
) else (
    echo %RED%No logs directory found.%RESET%
)
pause
goto advanced_menu

:end
echo %GREEN%Thank you for using Tabby Startup Manager!%RESET%
endlocal
