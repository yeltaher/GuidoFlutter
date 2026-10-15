@echo off
title Guido VR - Respirazione Fuoco Preview Server
echo ============================================================
echo   GUIDO VR - Modulo Respirazione Fuoco (Three.js 432 Hz)
echo   Sama Vritti - Respirazione Quadrata 4-4-4-4 (Sacred Fire)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8091/ ...
    start "" "http://localhost:8091/index.html"
    python -m http.server 8091
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8091/ ...
        start "" "http://localhost:8091/index.html"
        py -m http.server 8091
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html"
        pause
    )
)
