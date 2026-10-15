@echo off
title Guido VR - Meditazione Mattino Acqua Preview Server (8094)
echo ============================================================
echo   GUIDO VR - Meditazione del Mattino (Elemento Acqua)
echo   Suite Meditazioni Guidate (432 Hz - 8 Scene Timeline)
echo ============================================================
echo.
echo Avvio in corso del server di anteprima locale su porta 8094...

cd /d "%~dp0"

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python trovato. Avvio HTTP Server su http://localhost:8094/ ...
    start "" "http://localhost:8094/index.html"
    python -m http.server 8094
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Python launcher trovato. Avvio HTTP Server su http://localhost:8094/ ...
        start "" "http://localhost:8094/index.html"
        py -m http.server 8094
    ) else (
        echo [INFO] Python non rilevato nel PATH. Apertura diretta del file nel browser...
        start "" "%~dp0index.html"
        pause
    )
)
