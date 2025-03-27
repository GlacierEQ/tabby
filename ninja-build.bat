@echo off
echo ===== Running Ninja Build =====

set PYTHON_SCRIPTS=%USERPROFILE%\AppData\Roaming\Python\Python313\Scripts
set PATH=%PYTHON_SCRIPTS%;%PATH%

if not exist "%PYTHON_SCRIPTS%\ninja.exe" (
    echo Ninja not found in Python scripts directory
    echo Installing ninja via pip...
    pip install ninja
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to install ninja via pip
        exit /b 1
    )
)

echo Using Ninja from: %PYTHON_SCRIPTS%\ninja.exe
"%PYTHON_SCRIPTS%\ninja.exe" %*
