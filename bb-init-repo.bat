@echo off
echo Initializing Backblaze B2 restic repository...
echo.

if not exist config.txt (
    echo config.txt not found! Please create it with your configuration.
    echo Format should be:
    echo BACKUP_PATH=C:\Users\YourUser\Documents
    echo B2_ACCOUNT_ID=your_account_id
    echo B2_APPLICATION_KEY=your_application_key
    echo BUCKET_NAME=your-bucket-name
    pause
    exit /b 1
)

REM Read configuration from file
for /f "tokens=1,2 delims==" %%a in (config.txt) do (
    if "%%a"=="B2_ACCOUNT_ID" set B2_ACCOUNT_ID=%%b
    if "%%a"=="B2_APPLICATION_KEY" set B2_APPLICATION_KEY=%%b
    if "%%a"=="BUCKET_NAME" set BUCKET_NAME=%%b
)

if "%B2_ACCOUNT_ID%"=="" (
    echo B2_ACCOUNT_ID not found in config.txt
    pause
    exit /b 1
)

if "%B2_APPLICATION_KEY%"=="" (
    echo B2_APPLICATION_KEY not found in config.txt
    pause
    exit /b 1
)

if "%BUCKET_NAME%"=="" (
    echo BUCKET_NAME not found in config.txt
    pause
    exit /b 1
)

powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); $env:B2_ACCOUNT_ID = '%B2_ACCOUNT_ID%'; $env:B2_APPLICATION_KEY = '%B2_APPLICATION_KEY%'; & '.\restic.exe' init --repo 'b2:%BUCKET_NAME%:/'"

if %errorlevel% equ 0 (
    echo.
    echo Repository initialized successfully!
    echo.
    echo Setting retention policy (keep daily 7, weekly 4, monthly 12)...
    powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); $env:B2_ACCOUNT_ID = '%B2_ACCOUNT_ID%'; $env:B2_APPLICATION_KEY = '%B2_APPLICATION_KEY%'; & '.\restic.exe' forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --repo 'b2:%BUCKET_NAME%:/'"
    echo Retention policy set!
) else (
    echo.
    echo Failed to initialize repository.
)

pause