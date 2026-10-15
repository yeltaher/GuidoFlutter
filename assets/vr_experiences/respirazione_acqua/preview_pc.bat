@echo off
title Guido VR - Respirazione Acqua Preview Server
echo ============================================================
echo   GUIDO VR - Modulo Respirazione Acqua (Three.js 432 Hz)
echo   Nadi Shodhana - Narici Alternate (432 Hz Theta Beat)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8089/ ...
    start "" "http://localhost:8089/index.html"
    python -m http.server 8089
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8089/ ...
        start "" "http://localhost:8089/index.html"
        py -m http.server 8089
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html"
        pause
    )
)
