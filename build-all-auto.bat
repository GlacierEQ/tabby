@echo off
setlocal enabledelayedexpansion
title Tabby Automated Build Manager

REM Set up colors for output
set "CYAN=[36m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "BLUE=[34m"
set "MAGENTA=[35m"
set "RESET=[0m"

REM Create logs directory
if not exist logs mkdir logs

REM Log with timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%_%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"
set "LOG=logs\build_%timestamp%.log"

echo %CYAN%==============================================%RESET%
echo %CYAN%       TABBY AUTOMATED BUILD SYSTEM          %RESET%
echo %CYAN%==============================================%RESET%
echo.
echo %YELLOW%Log file: %LOG%%RESET%
echo.

REM Process command-line arguments
set "BUILD_TYPE=all"
set "PARALLEL=true"
set "CLEAN=false"
set "NOTIFY=false"
set "INSTALL_DEPS=true"
set "CUDA=false"
set "ROCM=false"
set "DEBUG=false"
set "RUN_AFTER=false"

:parse_args
if "%1"=="" goto after_args
if /i "%1"=="--release" set "BUILD_TYPE=release"
if /i "%1"=="--debug" set "BUILD_TYPE=debug" & set "DEBUG=true"
if /i "%1"=="--cuda" set "BUILD_TYPE=cuda" & set "CUDA=true"
if /i "%1"=="--rocm" set "BUILD_TYPE=rocm" & set "ROCM=true"
if /i "%1"=="--all" set "BUILD_TYPE=all"
if /i "%1"=="--clean" set "CLEAN=true"
if /i "%1"=="--notify" set "NOTIFY=true"
if /i "%1"=="--no-parallel" set "PARALLEL=false"
if /i "%1"=="--no-deps" set "INSTALL_DEPS=false"
if /i "%1"=="--run" set "RUN_AFTER=true"
shift
goto parse_args

:after_args

REM Start building
echo %CYAN%Starting automated build for: %BUILD_TYPE%%RESET%
echo %CYAN%Options: Parallel=%PARALLEL%, Clean=%CLEAN%, InstallDeps=%INSTALL_DEPS%, CUDA=%CUDA%, Debug=%DEBUG%%RESET%

REM Install dependencies if required
if "%INSTALL_DEPS%"=="true" (
    echo %YELLOW%Checking and installing dependencies...%RESET%
    call :run_with_color "%MAGENTA%" "powershell -ExecutionPolicy Bypass -File scripts\verify_tools.ps1 -Quiet"
    if %ERRORLEVEL% NEQ 0 (
        echo %YELLOW%Installing required build tools...%RESET%
        call :run_with_color "%MAGENTA%" "powershell -ExecutionPolicy Bypass -File scripts\install-ninja.ps1"
        call :run_with_color "%MAGENTA%" "powershell -ExecutionPolicy Bypass -File scripts\install-cmake.ps1"
    )
)

REM Set up environment
if exist "%USERPROFILE%\.cargo\bin" set "PATH=%USERPROFILE%\.cargo\bin;%PATH%"
if exist "%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts" set "PATH=%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts;%PATH%"

REM Get processor count for parallel builds
for /f "tokens=*" %%i in ('powershell -Command "[Math]::Max(1, [Environment]::ProcessorCount)"') do set CORES=%%i

REM Clean if requested
if "%CLEAN%"=="true" (
    echo %YELLOW%Cleaning previous build artifacts...%RESET%
    call :run_with_color "%RED%" "if exist build\cmake-* rd /s /q build\cmake-*"
    call :run_with_color "%RED%" "if exist target rd /s /q target"
)

REM Build based on requested type
if "%BUILD_TYPE%"=="all" (
    echo %CYAN%Building all configurations...%RESET%
    call :build_all
) else if "%BUILD_TYPE%"=="release" (
    echo %CYAN%Building release configuration...%RESET%
    call :build_release
) else if "%BUILD_TYPE%"=="debug" (
    echo %CYAN%Building debug configuration...%RESET%
    call :build_debug
) else if "%BUILD_TYPE%"=="cuda" (
    echo %CYAN%Building CUDA configuration...%RESET%
    call :build_cuda
) else if "%BUILD_TYPE%"=="rocm" (
    echo %CYAN%Building ROCm configuration...%RESET%
    call :build_rocm
)

REM Check if build was successful
if %ERRORLEVEL% NEQ 0 (
    echo %RED%Build failed with error code %ERRORLEVEL% !%RESET%
    if "%NOTIFY%"=="true" (
        powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Tabby build failed!', 'Build Alert', 'OK', 'Error')}"
    )
    exit /b %ERRORLEVEL%
)

echo %GREEN%Build completed successfully!%RESET%
if "%NOTIFY%"=="true" (
    powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Tabby build completed successfully!', 'Build Alert', 'OK', 'Information')}"
)

REM Run Tabby after build if requested
if "%RUN_AFTER%"=="true" (
    echo %GREEN%Starting Tabby...%RESET%
    if "%CUDA%"=="true" (
        call run-tabby.bat cuda
    ) else if "%ROCM%"=="true" (
        call run-tabby.bat rocm
    ) else (
        call run-tabby.bat cpu
    )
)

exit /b 0

REM === Build Functions ===

:build_all
echo %CYAN%=== Building All Configurations ===%RESET%
if "%PARALLEL%"=="true" (
    echo %YELLOW%Building configurations in parallel...%RESET%
    start "Tabby Release Build" cmd /c "call :build_release_impl > logs\build_release_%timestamp%.log 2>&1"
    start "Tabby Debug Build" cmd /c "call :build_debug_impl > logs\build_debug_%timestamp%.log 2>&1"
    start "Tabby CUDA Build" cmd /c "call :build_cuda_impl > logs\build_cuda_%timestamp%.log 2>&1"
    
    REM Wait for builds to complete (simplified approach)
    timeout /t 5 /nobreak > nul
    :wait_loop
    tasklist /fi "windowtitle eq Tabby*Build" /fo csv 2>nul | find /i "cmd.exe" > nul
    if %ERRORLEVEL% EQU 0 (
        echo %YELLOW%Waiting for builds to complete...%RESET%
        timeout /t 10 /nobreak > nul
        goto wait_loop
    )
    
    echo %GREEN%All parallel builds completed%RESET%
) else (
    call :build_release
    call :build_debug
    call :build_cuda
)
goto :eof

:build_release
call :run_with_color "%GREEN%" "echo Building release version..."
call :build_release_impl
goto :eof

:build_release_impl
if exist build\cmake-Release rd /s /q build\cmake-Release
mkdir build\cmake-Release
pushd build\cmake-Release
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build . -- -j%CORES%
popd
goto :eof

:build_debug
call :run_with_color "%BLUE%" "echo Building debug version..."
call :build_debug_impl
goto :eof

:build_debug_impl
if exist build\cmake-Debug rd /s /q build\cmake-Debug
mkdir build\cmake-Debug
pushd build\cmake-Debug
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Debug
cmake --build . -- -j%CORES%
popd
goto :eof

:build_cuda
call :run_with_color "%MAGENTA%" "echo Building CUDA version..."
call :build_cuda_impl
goto :eof

:build_cuda_impl
if exist build\cmake-CUDA rd /s /q build\cmake-CUDA
mkdir build\cmake-CUDA
pushd build\cmake-CUDA
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DTABBY_USE_CUDA=ON
cmake --build . -- -j%CORES%
popd
goto :eof

:build_rocm
call :run_with_color "%CYAN%" "echo Building ROCm version..."
if exist build\cmake-ROCm rd /s /q build\cmake-ROCm
mkdir build\cmake-ROCm
pushd build\cmake-ROCm
cmake ..\.. -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DTABBY_USE_ROCM=ON
cmake --build . -- -j%CORES%
popd
goto :eof

REM === Utility Functions ===

:run_with_color
echo %~1%~2%RESET%
%~2
goto :eof
