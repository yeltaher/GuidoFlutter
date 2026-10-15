@echo off
title Guido VR - Meditazione Pomeriggio Acqua Preview Server (8085)
echo ============================================================
echo   GUIDO VR - Meditazione del Pomeriggio (Elemento Acqua)
echo   Suite Meditazioni Guidate (432 Hz - Sole Zenitale e Fiordo)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale su porta 8085...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8085/ ...
    start "" "http://localhost:8085/index.html"
    python -m http.server 8085
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8085/ ...
        start "" "http://localhost:8085/index.html"
        py -m http.server 8085
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html"
        pause
    )
)
