# Script to install CMake for Windows

Write-Host "Installing CMake..." -ForegroundColor Cyan

try {
    Write-Host "Downloading CMake installer..." -ForegroundColor Yellow
    
    # Determine architecture
    $is64Bit = [Environment]::Is64BitOperatingSystem
    $cmakeUrl = if ($is64Bit) {
        "https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-windows-x86_64.msi"
    } else {
        "https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-windows-i386.msi"
    }
    
    $installerPath = "C:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\tools\cmake_installer.msi"
    
    # Create directory if it doesn't exist
    New-Item -ItemType Directory -Path (Split-Path $installerPath) -Force | Out-Null
    
    # Download CMake installer
    Invoke-WebRequest -Uri $cmakeUrl -OutFile $installerPath
    
    Write-Host "Installing CMake (this will require administrator privileges)..." -ForegroundColor Yellow
    Write-Host "Please respond to any UAC prompts that appear." -ForegroundColor Yellow
    
    # Install CMake
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /qb" -Wait
    
    # Check if CMake is now in PATH
    if (Get-Command "cmake" -ErrorAction SilentlyContinue) {
        Write-Host "CMake installed successfully!" -ForegroundColor Green
        return $true
    }
    
    # If not in PATH, check common installation locations
    $cmakePaths = @(
        "C:\Program Files\CMake\bin",
        "C:\Program Files (x86)\CMake\bin"
    )
    
    foreach ($path in $cmakePaths) {
        if (Test-Path (Join-Path $path "cmake.exe")) {
            $env:PATH = "$path;$env:PATH"
            Write-Host "Added CMake to PATH for current session: $path" -ForegroundColor Green
            
            # Create a batch file to use this CMake
            $cmakeWrapperPath = "C:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\cmake.bat"
@"
@echo off
set PATH=$($path.Replace('\', '\\'));%PATH%
"$path\cmake.exe" %*
"@ | Out-File -FilePath $cmakeWrapperPath -Encoding ascii
            
            Write-Host "Created wrapper batch file at: $cmakeWrapperPath" -ForegroundColor Green
            return $true
        }
    }
    
    Write-Host "CMake installer completed, but CMake was not found in PATH." -ForegroundColor Yellow
    Write-Host "You may need to restart your PowerShell session for changes to take effect." -ForegroundColor Yellow
} catch {
    Write-Host "Failed to install CMake: $_" -ForegroundColor Red
}

Write-Host "Manual installation instructions:" -ForegroundColor Yellow
Write-Host "1. Download CMake from: https://cmake.org/download/" -ForegroundColor Yellow
Write-Host "2. Install CMake and ensure 'Add to PATH' is selected" -ForegroundColor Yellow
Write-Host "3. Restart your PowerShell session" -ForegroundColor Yellow

return $false
