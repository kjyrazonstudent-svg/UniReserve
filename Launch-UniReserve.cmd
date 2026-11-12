@echo off
title UniReserve – University of the Assumption
cd /d "%~dp0"
if exist "node_modules\electron\dist\electron.exe" (
    start "" "node_modules\electron\dist\electron.exe" .
    exit /b 0
)
npm start
