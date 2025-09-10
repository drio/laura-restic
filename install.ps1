$ProgressPreference = 'SilentlyContinue'
$baseUrl = "https://data.drio.sh/restic/"
$files = @(
    "restic.exe",
    "Restic-Browser.exe", 
    "local-init-repo.bat",
    "local-backup.bat",
    "bb-init-repo.bat",
    "bb-backup.bat",
    "local-test-integrity.bat",
    "bb-test-integrity.bat",
    "config.txt"
)

Write-Host "Downloading Restic Backup System..."

foreach ($file in $files) {
    if ($file -eq "config.txt" -and (Test-Path $file)) {
        Write-Host "Skipping $file (already exists)" -ForegroundColor Yellow
        continue
    }

    Write-Host "Downloading $file..."
    try {
        Invoke-WebRequest -Uri "$baseUrl$file" -OutFile $file -ErrorAction Stop
        Write-Host "Success: $file" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed: $file - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Download complete!"
pause
