@echo off
title UniReserve – University of the Assumption
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0' -Recurse | Unblock-File -ErrorAction SilentlyContinue"
if exist "dist\UniReserve 1.0.0.exe" (
    start "" "dist\UniReserve 1.0.0.exe"
    exit /b 0
)
if exist "node_modules\electron\dist\electron.exe" (
    start "" "node_modules\electron\dist\electron.exe" .
    exit /b 0
)
npm start
