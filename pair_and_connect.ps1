# Wireless Debugging Pair and Connect Script
$ANDROID_HOME = "C:\Users\Hamza\AppData\Local\Android\sdk"
$ADB = "$ANDROID_HOME\platform-tools\adb.exe"

Write-Host "=== Pairing Device ===" -ForegroundColor Cyan
Write-Host "Pairing with 192.168.100.71:37961..." -ForegroundColor Yellow
Write-Host "When prompted, enter the pairing code: 017194" -ForegroundColor Yellow
Write-Host ""

& $ADB pair 192.168.100.71:37961

Write-Host ""
Write-Host "=== Checking for connection port ===" -ForegroundColor Cyan
Write-Host "After pairing, check your phone for the new IP address & port" -ForegroundColor Yellow
Write-Host "Then run: adb connect IP:PORT" -ForegroundColor Yellow

