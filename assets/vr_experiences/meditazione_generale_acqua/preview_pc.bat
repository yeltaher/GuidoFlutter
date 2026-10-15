@echo off
title Guido VR - Meditazione Generale Acqua Preview Server (8097)
echo ============================================================
echo   GUIDO VR - Meditazione Generale (Elemento Acqua)
echo   Suite Meditazioni Guidate (432 Hz - 16 Scene Timeline)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale su porta 8097...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8097/ ...
    start "" "http://localhost:8097/index.html?desktop=true"
    python -m http.server 8097
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8097/ ...
        start "" "http://localhost:8097/index.html?desktop=true"
        py -m http.server 8097
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html?desktop=true"
        pause
    )
)
