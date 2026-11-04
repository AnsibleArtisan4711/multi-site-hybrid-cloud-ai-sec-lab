# Quelle: docs/10-backup-disaster-recovery/10.4-sekundaer-speicher-a-cloud-gateway-google-drive.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

$RcloneExe = "C:\rclone\rclone.exe"
# Welche Backups sollen in die Cloud? (Pfade anpassen)
$SourcePath = "B:\VeeamBackups\"
$RemotePath = "GDrive:Veeam_Offsite_Backup"
# Archivordner mit Datum fuer lokal geloeschte oder geaenderte Dateien
$ArchivePath = "GDrive:Veeam_Offsite_Archiv/" + (Get-Date -Format "yyyy-MM-dd")
# Startet den Sync. Lokal geloeschte oder geaenderte Dateien werden in den Archivordner verschoben und nicht in der Cloud geloescht.
& $RcloneExe sync $SourcePath $RemotePath --backup-dir $ArchivePath --transfers 4 --checkers 8 --verbose --log-file "C:\Logs\rclone_sync.log"
