@echo off
cd /d "%~dp0"
echo Running Backblaze B2 backup integrity test...
echo.

if not exist config.txt (
    echo config.txt not found! Please create it with your configuration.
    echo Format should include:
    echo BACKUP_PATH=C:\Users\YourUser\Documents
    echo B2_ACCOUNT_ID=your_account_id
    echo B2_ACCOUNT_KEY=your_application_key
    echo BUCKET_NAME=your-bucket-name
    pause
    exit /b 1
)

REM Read configuration from file
for /f "tokens=1,2 delims==" %%a in (config.txt) do (
    if "%%a"=="B2_ACCOUNT_ID" set B2_ACCOUNT_ID=%%b
    if "%%a"=="B2_ACCOUNT_KEY" set B2_ACCOUNT_KEY=%%b
    if "%%a"=="BUCKET_NAME" set BUCKET_NAME=%%b
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

echo Testing integrity of Backblaze B2 repository: %BUCKET_NAME%
echo.

powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); $env:B2_ACCOUNT_ID = '%B2_ACCOUNT_ID%'; $env:B2_ACCOUNT_KEY = '%B2_ACCOUNT_KEY%'; & '.\restic.exe' check --repo 'b2:%BUCKET_NAME%:/'"

if %errorlevel% equ 0 (
    echo.
    echo ✓ Backblaze backup integrity test passed! Repository is healthy.
    echo.
    echo Running additional verification (this may take longer)...
    powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password (same as above)'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); $env:B2_ACCOUNT_ID = '%B2_ACCOUNT_ID%'; $env:B2_ACCOUNT_KEY = '%B2_ACCOUNT_KEY%'; & '.\restic.exe' check --repo 'b2:%BUCKET_NAME%:/' --read-data"
    
    if %errorlevel% equ 0 (
        echo.
        echo ✓ Complete integrity test passed! All data verified.
    ) else (
        echo.
        echo ⚠ Data verification failed. Repository structure is OK but some data may be corrupted.
    )
) else (
    echo.
    echo ✗ Backblaze backup integrity test failed! Repository may have issues.
)

pause