# Script to install Ninja build tool for Windows

param (
    [switch]$Quiet
)

if (-not $Quiet) {
    Write-Host "Installing Ninja build system..." -ForegroundColor Cyan
}

# Try to install via pip first
try {
    if (-not $Quiet) {
        Write-Host "Attempting to install Ninja via pip..." -ForegroundColor Yellow
    }
    pip install --user ninja
    
    # Check if installation succeeded
    $pythonScripts = "$env:USERPROFILE\AppData\Roaming\Python\*\Scripts"
    $ninjaExe = Get-ChildItem -Path $pythonScripts -Filter "ninja.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($ninjaExe) {
        $ninjaPath = $ninjaExe.DirectoryName
        if (-not $Quiet) {
            Write-Host "Successfully installed Ninja via pip at: $ninjaPath" -ForegroundColor Green
        }
        
        # Add to session PATH
        $env:PATH = "$ninjaPath;$env:PATH"
        if (-not $Quiet) {
            Write-Host "Added Ninja to PATH for current session" -ForegroundColor Green
        }
        
        # Create a batch file to use this Ninja
        $ninjaWrapperPath = "C:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\ninja.bat"
@"
@echo off
set PATH=$($ninjaPath.Replace('\', '\\'));%PATH%
"$($ninjaExe.FullName)" %*
"@ | Out-File -FilePath $ninjaWrapperPath -Encoding ascii
        
        if (-not $Quiet) {
            Write-Host "Created wrapper batch file at: $ninjaWrapperPath" -ForegroundColor Green
        }
        return $true
    }
} catch {
    if (-not $Quiet) {
        Write-Host "Failed to install Ninja via pip: $_" -ForegroundColor Red
    }
}

# If pip install failed, download binary directly
try {
    if (-not $Quiet) {
        Write-Host "Attempting to download Ninja binary directly..." -ForegroundColor Yellow
    }
    
    # Prepare directory
    $ninjaDir = "C:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\tools\ninja"
    New-Item -ItemType Directory -Path $ninjaDir -Force | Out-Null
    
    # Download latest release
    $ninjaUrl = "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-win.zip"
    $zipPath = Join-Path $ninjaDir "ninja.zip"
    
    Invoke-WebRequest -Uri $ninjaUrl -OutFile $zipPath
    
    # Extract
    Expand-Archive -Path $zipPath -DestinationPath $ninjaDir -Force
    Remove-Item $zipPath
    
    # Check if extraction worked
    if (Test-Path (Join-Path $ninjaDir "ninja.exe")) {
        if (-not $Quiet) {
            Write-Host "Successfully downloaded and extracted Ninja to: $ninjaDir" -ForegroundColor Green
        }
        
        # Add to session PATH
        $env:PATH = "$ninjaDir;$env:PATH"
        if (-not $Quiet) {
            Write-Host "Added Ninja to PATH for current session" -ForegroundColor Green
        }
        
        # Create a batch file to use this Ninja
        $ninjaWrapperPath = "C:\Users\casey\Cloud-Drive_higuy.vids@gmail.com\GITHUB\tabby\ninja.bat"
@"
@echo off
set PATH=$($ninjaDir.Replace('\', '\\'));%PATH%
"$ninjaDir\ninja.exe" %*
"@ | Out-File -FilePath $ninjaWrapperPath -Encoding ascii
        
        if (-not $Quiet) {
            Write-Host "Created wrapper batch file at: $ninjaWrapperPath" -ForegroundColor Green
        }
        return $true
    }
} catch {
    if (-not $Quiet) {
        Write-Host "Failed to download and extract Ninja: $_" -ForegroundColor Red
    }
}

if (-not $Quiet) {
    Write-Host "Failed to install Ninja automatically." -ForegroundColor Red
    Write-Host "Please download and install manually from: https://github.com/ninja-build/ninja/releases" -ForegroundColor Yellow
}
return $false
