$ProgressPreference = 'SilentlyContinue'
$baseUrl = "https://data.drio.sh/restic/"
$files = @(
    "restic.exe",
    "Restic-Browser.exe", 
    "init-repo.bat",
    "backup.bat"
)

Write-Host "Downloading Restic Backup System..."

foreach ($file in $files) {
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