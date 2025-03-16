# Simple script to directly use Ninja from Python installation

# Add Python scripts to PATH
$pythonScripts = "$env:USERPROFILE\AppData\Roaming\Python\Python313\Scripts"

if (Test-Path "$pythonScripts\ninja.exe") {
    # Add to PATH and announce
    $env:PATH = "$pythonScripts;$env:PATH"
    Write-Host "Using Ninja from Python installation at: $pythonScripts" -ForegroundColor Green
    
    # Show version
    $ninjaVersion = & "$pythonScripts\ninja.exe" --version
    Write-Host "Ninja version: $ninjaVersion" -ForegroundColor Cyan
    
    # If arguments were provided, pass them to Ninja
    if ($args.Count -gt 0) {
        & "$pythonScripts\ninja.exe" $args
    } else {
        Write-Host "No arguments provided. To use: .\scripts\direct-ninja-build.ps1 [ninja arguments]" -ForegroundColor Yellow
    }
} else {
    Write-Host "Ninja not found in Python scripts directory: $pythonScripts" -ForegroundColor Red
    Write-Host "Installing Ninja via pip..." -ForegroundColor Yellow
    pip install ninja
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ninja installed successfully. Please run this script again." -ForegroundColor Green
    } else {
        Write-Host "Failed to install Ninja via pip. Please install manually." -ForegroundColor Red
    }
}
