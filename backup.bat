@echo off
echo Running backup...
echo.

if not exist backup-path.txt (
    echo backup-path.txt not found! Please create it with the path to backup.
    pause
    exit /b 1
)

set /p BACKUP_PATH=<backup-path.txt
echo Backing up: %BACKUP_PATH%
powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); & '.\restic.exe' backup '%BACKUP_PATH%' --repo repo"

if %errorlevel% equ 0 (
    echo.
    echo Backup completed successfully!
) else (
    echo.
    echo Backup failed.
)

pause