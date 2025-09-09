@echo off
echo Opening restic browser...
echo.

powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); & '.\Restic-Browser.exe' --repo .\repo"

pause