@echo off
echo Running backup...
echo.

if not exist config.txt (
    echo config.txt not found! Please create it with your configuration.
    echo Format should include at minimum:
    echo BACKUP_PATH=C:\Users\YourUser\Documents
    pause
    exit /b 1
)

REM Read configuration from file
for /f "tokens=1,2 delims==" %%a in (config.txt) do (
    if "%%a"=="BACKUP_PATH" set BACKUP_PATH=%%b
)

if "%BACKUP_PATH%"=="" (
    echo BACKUP_PATH not found in config.txt
    pause
    exit /b 1
)
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