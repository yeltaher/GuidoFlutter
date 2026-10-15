@echo off
title Guido VR - Respirazione Terra Preview Server
echo ============================================================
echo   GUIDO VR - Modulo Respirazione Terra (Three.js 432 Hz)
echo   Respirazione 4-6-8 di Radicamento (Pianeta Terra 3D)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8093/ ...
    start "" "http://localhost:8093/index.html"
    python -m http.server 8093
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8093/ ...
        start "" "http://localhost:8093/index.html"
        py -m http.server 8093
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html"
        pause
    )
)
