@echo off
REM Simple entry point for building Tabby

echo Tabby Build System
echo.
echo Starting automatic build process...
powershell -ExecutionPolicy Bypass -File "%~dp0auto-build.ps1" %*

if %ERRORLEVEL% EQU 0 (
    echo Build completed successfully!
) else (
    echo Build encountered errors. Please check the output above.
    exit /b %ERRORLEVEL%
)
