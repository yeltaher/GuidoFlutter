@echo off
title Guido VR - Meditazione Sera Acqua Preview Server (8095)
echo ============================================================
echo   GUIDO VR - Meditazione della Sera (Elemento Acqua)
echo   Suite Meditazioni Guidate (432 Hz - 7 Scene Timeline)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale su porta 8095...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8095/ ...
    start "" "http://localhost:8095/index.html"
    python -m http.server 8095
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8095/ ...
        start "" "http://localhost:8095/index.html"
        py -m http.server 8095
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html"
        pause
    )
)
