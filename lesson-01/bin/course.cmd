@echo off
rem Windows entry point: runs course.ps1 without needing a PowerShell execution-policy change.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0course.ps1" %*
exit /b %ERRORLEVEL%
