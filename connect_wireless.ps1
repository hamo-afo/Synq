# Wireless Debugging Connection Script for Flutter
# Make sure your phone and computer are on the same WiFi network

$ANDROID_HOME = "C:\Users\Hamza\AppData\Local\Android\sdk"
$ADB = "$ANDROID_HOME\platform-tools\adb.exe"

Write-Host "=== Flutter Wireless Debugging Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check if device is connected via USB
Write-Host "Checking for USB-connected devices..." -ForegroundColor Yellow
$devices = & $ADB devices
if ($devices -match "device$") {
    Write-Host "✓ Device found via USB" -ForegroundColor Green
    Write-Host ""
    Write-Host "To enable wireless debugging:" -ForegroundColor Yellow
    Write-Host "1. On your phone: Settings → Developer options → Enable 'Wireless debugging'" -ForegroundColor White
    Write-Host "2. Tap 'Wireless debugging' → Note the IP address and port (e.g., 192.168.1.100:12345)" -ForegroundColor White
    Write-Host ""
    
    $ipPort = Read-Host "Enter the IP address and port from your phone (format: IP:PORT)"
    
    if ($ipPort) {
        Write-Host ""
        Write-Host "Connecting to $ipPort..." -ForegroundColor Yellow
        & $ADB connect $ipPort
        
        Write-Host ""
        Write-Host "Checking connection..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        & $ADB devices
        
        Write-Host ""
        Write-Host "✓ You can now disconnect USB and run: flutter run" -ForegroundColor Green
    }
} else {
    Write-Host "No device found via USB. Please connect your phone via USB first." -ForegroundColor Red
}

Write-Host ""
Write-Host "To disconnect wireless debugging later, run: adb disconnect" -ForegroundColor Cyan

