param(
    [string]$Configuration = "Release"
)

$ErrorActionPreference = "Stop"
$projectDir = Split-Path -Parent $PSScriptRoot
$modName = "QuickReload"
$sts2Root = "E:\game\Slay.the.Spire.2.Build.22823976.Win64.Public\Slay the Spire 2"
$modsDir = Join-Path $sts2Root "mods" $modName

Write-Host "Building $modName..." -ForegroundColor Cyan
dotnet build "$projectDir\$modName.csproj" -c $Configuration
if ($LASTEXITCODE -ne 0) { throw "Build failed" }

Write-Host "Deploying to $modsDir..." -ForegroundColor Cyan
if (-not (Test-Path $modsDir)) { New-Item -ItemType Directory -Path $modsDir -Force | Out-Null }

$dllSource = Join-Path $projectDir ".godot\mono\temp\bin\$Configuration\$modName.dll"
if (Test-Path $dllSource) {
    Copy-Item $dllSource (Join-Path $modsDir "$modName.dll") -Force
    Write-Host "  Copied $modName.dll" -ForegroundColor Green
} else {
    Write-Warning "  DLL not found at $dllSource; run 'dotnet build' first"
}

Copy-Item (Join-Path $projectDir "$modName.json") (Join-Path $modsDir "$modName.json") -Force
Write-Host "  Copied $modName.json" -ForegroundColor Green

Write-Host "Done." -ForegroundColor Cyan
