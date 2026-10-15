@echo off
title Guido VR - Respirazione Aria Preview Server
echo ============================================================
echo   GUIDO VR - Modulo Respirazione Aria (Three.js 432 Hz)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8088/ ...
    start "" "http://localhost:8088/index.html"
    python -m http.server 8088
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8088/ ...
        start "" "http://localhost:8088/index.html"
        py -m http.server 8088
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html"
        pause
    )
)
