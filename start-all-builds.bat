@echo off
setlocal enabledelayedexpansion
title Tabby Build Automation System

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

REM Set log directory and file
if not exist logs mkdir logs
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "logdate=%dt:~0,8%-%dt:~8,6%"
set "MASTER_LOG=logs\master-build-%logdate%.log"

REM Parse command line arguments
set "UNATTENDED="
set "CLEAN="
set "NOTIFY="
set "BUILD_TYPES=release debug cuda"

:parse_args
if "%1"=="" goto continue_after_args
if /i "%1"=="--unattended" set "UNATTENDED=1"
if /i "%1"=="--clean" set "CLEAN=1"
if /i "%1"=="--notify" set "NOTIFY=1"
if /i "%1"=="--release-only" set "BUILD_TYPES=release"
if /i "%1"=="--cuda-only" set "BUILD_TYPES=cuda"
shift
goto parse_args

:continue_after_args
echo %CYAN%Build Log: %MASTER_LOG%%RESET%
echo.

REM Save console output to log file
if defined UNATTENDED (
    echo Running in unattended mode with these builds: %BUILD_TYPES%
    echo Logging all output to %MASTER_LOG%
    call :run_builds > "%MASTER_LOG%" 2>&1
) else (
    echo Running interactively with these builds: %BUILD_TYPES%
    call :run_builds | Tee-Object -FilePath "%MASTER_LOG%"
)

REM Check if build was successful
if %errorlevel% neq 0 (
    echo %RED%Some builds failed! Check log for details.%RESET%
    if defined NOTIFY (
        powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Tabby build failed. Check log for details.', 'Build Alert', 'OK', 'Error')}"
    )
    exit /b 1
) else (
    echo %GREEN%All builds completed successfully!%RESET%
    if defined NOTIFY (
        powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('All Tabby builds completed successfully!', 'Build Alert', 'OK', 'Information')}"
    )
    exit /b 0
)

:run_builds
echo %CYAN%Starting automated build process...%RESET%
set "START_TIME=%TIME%"

REM Check and install required tools
echo Verifying build tools...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\verify_tools.ps1" -Quiet
if %errorlevel% neq 0 (
    echo Installing missing build tools...
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-ninja.ps1" -Quiet
    powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-cmake.ps1" -Quiet
)

REM Clean if requested
if defined CLEAN (
    echo %YELLOW%Cleaning all previous build artifacts...%RESET%
    if exist build\cmake-* rd /s /q build\cmake-*
    if exist target rd /s /q target
)

REM Run builds sequentially based on requested types
for %%b in (%BUILD_TYPES%) do (
    echo %CYAN%=======================================
    echo Starting %%b build
    echo =======================================%RESET%
    
    set "BUILD_START_TIME=%TIME%"
    
    if "%%b"=="release" (
        call "%~dp0WindowsBuild.bat"
    ) else if "%%b"=="debug" (
        call "%~dp0WindowsDebugBuild.bat"
    ) else if "%%b"=="cuda" (
        call "%~dp0WindowsCudaBuild.bat"
    )
    
    if !errorlevel! neq 0 (
        echo %RED%The %%b build failed with error code !errorlevel!%RESET%
        exit /b !errorlevel!
    ) else (
        echo %GREEN%The %%b build completed successfully%RESET%
    )
    
    REM Calculate build duration
    call :time_diff "!BUILD_START_TIME!" "%TIME%" build_duration
    echo Build duration: !build_duration!
    echo.
)

REM Calculate total duration
call :time_diff "%START_TIME%" "%TIME%" total_duration
echo %GREEN%All builds completed!%RESET%
echo Total build duration: %total_duration%

exit /b 0

:time_diff
REM Converts time strings into seconds, calculates difference, and formats result
setlocal
set "start=%~1"
set "end=%~2"

REM Convert start time to seconds
for /f "tokens=1-4 delims=:." %%a in ("%start%") do (
   set /a "start_seconds=(((%%a*60)+1%%b%%100)*60+1%%c%%100)*100+1%%d%%100"
)

REM Convert end time to seconds
for /f "tokens=1-4 delims=:." %%a in ("%end%") do (
   set /a "end_seconds=(((%%a*60)+1%%b%%100)*60+1%%c%%100)*100+1%%d%%100"
)

REM Calculate difference (handle midnight rollover)
set /a "diff_seconds=end_seconds-start_seconds"
if %diff_seconds% lss 0 set /a "diff_seconds+=24*60*60*100"

REM Convert back to hh:mm:ss format
set /a "diff_hours=diff_seconds/(60*60*100)", "diff_seconds%%=60*60*100"
set /a "diff_minutes=diff_seconds/(60*100)", "diff_seconds%%=60*100" 
set /a "diff_seconds=diff_seconds/100", "diff_centiseconds=diff_seconds%%100"

REM Format the output with leading zeros
if %diff_hours% lss 10 set "diff_hours=0%diff_hours%"
if %diff_minutes% lss 10 set "diff_minutes=0%diff_minutes%"
if %diff_seconds% lss 10 set "diff_seconds=0%diff_seconds%"

REM Return the result
endlocal & set "%~3=%diff_hours%:%diff_minutes%:%diff_seconds%"
exit /b 0
