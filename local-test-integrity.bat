@echo off
cd /d "%~dp0"
echo Running local backup integrity test...
echo.

if not exist config.txt (
    echo config.txt not found! Please create it with your configuration.
    pause
    exit /b 1
)

if not exist repo (
    echo Local repository 'repo' not found! Please initialize the repository first with init-repo.bat
    pause
    exit /b 1
)

echo Testing integrity of local repository...
powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); & '.\restic.exe' check --repo repo"

if %errorlevel% equ 0 (
    echo.
    echo ✓ Local backup integrity test passed! Repository is healthy.
    echo.
    echo Running additional verification...
    powershell -Command "$pw = Read-Host -AsSecureString 'Enter repository password (same as above)'; $env:RESTIC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)); & '.\restic.exe' check --repo repo --read-data"
    
    if %errorlevel% equ 0 (
        echo.
        echo ✓ Complete integrity test passed! All data verified.
    ) else (
        echo.
        echo ⚠ Data verification failed. Repository structure is OK but some data may be corrupted.
    )
) else (
    echo.
    echo ✗ Local backup integrity test failed! Repository may have issues.
)

pause