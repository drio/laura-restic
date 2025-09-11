# Restic Backup System

# Intro

This is a project that provides a backup strategy for windows boxes. 
The idea is that we want to backup a directory/folder. We will keep the data
in 3 places. The local drive, secondary storage (USB drive) and a backblaze 
bucket.
The backups are done using restic. This gives us a couple of things:

1. The backups are encrypted. Details:

Restic uses AES-256 in Counter (CTR) mode with Poly1305-AES for authentication.

  - Encryption: AES-256-CTR
  - Authentication: Poly1305-AES
  - Key derivation: scrypt (configurable parameters)
  - Overhead: 32 bytes per encrypted block (16-byte IV + 16-byte MAC)

Key derivation in Restic uses scrypt - a password-based key derivation
function designed to be computationally expensive and memory-hard to resist
brute-force attacks.

2. Snapshots:

Restic creates incremental backups, so you can go back in time to check the status of a file. 
See the scripts for the retention policies.

## Locations of the binaries we use here:

- **Restic**: https://github.com/restic/restic/releases/latest
- **Restic Browser**: https://github.com/emuell/restic-browser/releases/latest

## Usage

1. Download the install.ps1 to a USB drive (or wherever) and run it:
   ```
   powershell -ExecutionPolicy Bypass -File install.ps1
   ```

2. **Test backup workflow**:
   1. Update `config.txt` with your options.
   2. Run `init-repo.bat`  (only once, creates the restic repo)
   3. Run `backup.bat` (triggers a backup)
   4. Run Restic-Browser.exe to navigate the backup and restore files.
      NOTE: you can save the profiles so you can load them automatically.

Now, you can repeat using the bb-* scripts to work against backblaze.

You can use the *integrity* scripts to check the integrity of the restic repos, both for bb and local.

## TODO

- [ ] Read password from local file
- [ ] Schedule run backups
