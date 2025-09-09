# Restic Backup System

## Manual Downloads

- **Restic**: https://github.com/restic/restic/releases/latest
- **Restic Browser**: https://github.com/emuell/restic-browser/releases/latest

## Usage

1. **Test PowerShell download** (from Windows):
   ```
   powershell -ExecutionPolicy Bypass -File install.ps1
   ```

2. **Test backup workflow**:
   - Run `init-repo.bat`  (sets the restic repo)
      - Update `confit.txt` with your data.
   - Run `backup.bat` (runs a backup)
   - Run Restic-Browser.exe to navigate the backup and restore files.
