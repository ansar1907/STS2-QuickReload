Write-Host "Killing any running STS2 instances..." -ForegroundColor Cyan
Get-Process -Name "SlayTheSpire2" -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "Done." -ForegroundColor Green
