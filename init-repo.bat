@echo off
echo Initializing restic repository...
echo.

if exist repo\ (
    echo Repository directory already exists! Aborting.
    pause
    exit /b 1
)

powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); & '.\restic.exe' init --repo repo"

if %errorlevel% equ 0 (
    echo.
    echo Repository initialized successfully!
) else (
    echo.
    echo Failed to initialize repository.
)

pause