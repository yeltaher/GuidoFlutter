# Guido VR - Preview Script PowerShell (Porta 8097)
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  GUIDO VR - Meditazione Generale (Elemento Acqua)" -ForegroundColor Cyan
Write-Host "  Suite Meditazioni Guidate (432 Hz - 16 Scene Timeline)" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

$pythonPath = (Get-Command python -ErrorAction SilentlyContinue)
if ($pythonPath) {
    Write-Host "[OK] Avvio HTTP Server su http://localhost:8097/index.html?desktop=true ..." -ForegroundColor Green
    Start-Process "http://localhost:8097/index.html?desktop=true"
    python -m http.server 8097
} else {
    Write-Host "[INFO] Apertura file locale nel browser..." -ForegroundColor Yellow
    Start-Process "$dir\index.html?desktop=true"
}
