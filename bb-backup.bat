@echo off
echo Running Backblaze B2 backup...
echo.

if not exist config.txt (
    echo config.txt not found! Please create it with your configuration.
    echo Format should be:
    echo BACKUP_PATH=C:\Users\YourUser\Documents
    echo B2_ACCOUNT_ID=your_account_id
    echo B2_ACCOUNT_KEY=your_application_key
    echo BUCKET_NAME=your-bucket-name
    pause
    exit /b 1
)

REM Read configuration from file
for /f "tokens=1,2 delims==" %%a in (config.txt) do (
    if "%%a"=="BACKUP_PATH" set BACKUP_PATH=%%b
    if "%%a"=="B2_ACCOUNT_ID" set B2_ACCOUNT_ID=%%b
    if "%%a"=="B2_ACCOUNT_KEY" set B2_ACCOUNT_KEY=%%b
    if "%%a"=="BUCKET_NAME" set BUCKET_NAME=%%b
)

echo Backing up: %BACKUP_PATH%

if "%BACKUP_PATH%"=="" (
    echo BACKUP_PATH not found in config.txt
    pause
    exit /b 1
)

if "%B2_ACCOUNT_ID%"=="" (
    echo B2_ACCOUNT_ID not found in config.txt
    pause
    exit /b 1
)

if "%B2_ACCOUNT_KEY%"=="" (
    echo B2_ACCOUNT_KEY not found in config.txt
    pause
    exit /b 1
)

if "%BUCKET_NAME%"=="" (
    echo BUCKET_NAME not found in config.txt
    pause
    exit /b 1
)

REM Prompt for repository password and run backup
powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); $env:B2_ACCOUNT_ID = '%B2_ACCOUNT_ID%'; $env:B2_ACCOUNT_KEY = '%B2_ACCOUNT_KEY%'; & '.\restic.exe' backup '%BACKUP_PATH%' --repo 'b2:%BUCKET_NAME%:/'"

if %errorlevel% equ 0 (
    echo.
    echo Backup completed successfully!
) else (
    echo.
    echo Backup failed.
)

pause