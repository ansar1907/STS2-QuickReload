param(
    [string]$Configuration = "Release",
    [switch]$NoDebug
)

$ErrorActionPreference = "Stop"
$projectDir = Split-Path -Parent $PSScriptRoot
$modName = "QuickReload"
$sts2Root = "E:\game\Slay.the.Spire.2.Build.22823976.Win64.Public\Slay the Spire 2"
$sts2Exe = Join-Path $sts2Root "SlayTheSpire2.exe"

Write-Host "Building $modName..." -ForegroundColor Cyan
dotnet build "$projectDir\$modName.csproj" -c $Configuration
if ($LASTEXITCODE -ne 0) { throw "Build failed" }

Write-Host "Killing any running STS2 instances..." -ForegroundColor Cyan
Get-Process -Name "SlayTheSpire2" -ErrorAction SilentlyContinue | Stop-Process -Force

Start-Sleep -Seconds 1

$argsList = @("--force-steam", "off")
if (-not $NoDebug) {
    $argsList += "--remote-debug"
    $argsList += "tcp://127.0.0.1:6007"
}

Write-Host "Launching STS2..." -ForegroundColor Cyan
Start-Process -FilePath $sts2Exe -ArgumentList $argsList
Write-Host "Launched with args: $argsList" -ForegroundColor Green
