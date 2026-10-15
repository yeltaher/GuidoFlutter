# Guido VR - Preview Script PowerShell (Porta 8095)
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  GUIDO VR - Meditazione della Sera (Elemento Acqua)" -ForegroundColor Cyan
Write-Host "  Suite Meditazioni Guidate (432 Hz - 7 Scene Timeline)" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

$pythonPath = (Get-Command python -ErrorAction SilentlyContinue)
if ($pythonPath) {
    Write-Host "[OK] Avvio HTTP Server su http://localhost:8095/index.html ..." -ForegroundColor Green
    Start-Process "http://localhost:8095/index.html"
    python -m http.server 8095
} else {
    Write-Host "[INFO] Apertura file locale nel browser..." -ForegroundColor Yellow
    Start-Process "$dir\index.html"
}
