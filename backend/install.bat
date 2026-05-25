@echo off
cd /d "%~dp0"
call npm.cmd install
if errorlevel 1 pause
else echo.
echo Done. Chay start.bat de bat API.
pause
