# Guido VR - Preview Script PowerShell
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  GUIDO VR - Modulo Respirazione Terra (Three.js 432 Hz)" -ForegroundColor Cyan
Write-Host "  Respirazione 4-6-8 di Radicamento (Pianeta Terra 3D)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

$pythonPath = (Get-Command python -ErrorAction SilentlyContinue)
if ($pythonPath) {
    Write-Host "[OK] Avvio HTTP Server su http://localhost:8093/index.html ..." -ForegroundColor Green
    Start-Process "http://localhost:8093/index.html"
    python -m http.server 8093
} else {
    Write-Host "[INFO] Apertura file locale nel browser..." -ForegroundColor Yellow
    Start-Process "$dir\index.html"
}
