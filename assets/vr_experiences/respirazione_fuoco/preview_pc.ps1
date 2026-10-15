# Guido VR - Preview Script PowerShell
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  GUIDO VR - Modulo Respirazione Fuoco (Three.js 432 Hz)" -ForegroundColor Cyan
Write-Host "  Sama Vritti - Respirazione Quadrata 4-4-4-4 (Sacred Fire)" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

$pythonPath = (Get-Command python -ErrorAction SilentlyContinue)
if ($pythonPath) {
    Write-Host "[OK] Avvio HTTP Server su http://localhost:8091/index.html ..." -ForegroundColor Green
    Start-Process "http://localhost:8091/index.html"
    python -m http.server 8091
} else {
    Write-Host "[INFO] Apertura file locale nel browser..." -ForegroundColor Yellow
    Start-Process "$dir\index.html"
}
