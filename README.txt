# Restic Backup System

## Installation

Run from Command Prompt:
```
powershell -ExecutionPolicy Bypass -File install.ps1
```

## Testing

1. **Deploy files to webserver**:
   ```
   make deploy
   ```

2. **Test PowerShell download** (from Windows):
   ```
   powershell -ExecutionPolicy Bypass -File install.ps1
   ```

3. **Test backup workflow**:
   - Run `init-repo.bat` 
   - Create `backup-path.txt` with test directory
   - Run `backup.bat`
   - Run `browser.bat` to verify files