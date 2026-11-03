# Quelle: docs/10-backup-disaster-recovery/10.4-sekundaer-speicher-a-cloud-gateway-google-drive.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

$RcloneExe = "C:\rclone\rclone.exe"
# Welche Backups sollen in die Cloud? (Pfade anpassen)
$SourcePath = "B:\VeeamBackups\"
$RemotePath = "GDrive:Veeam_Offsite_Backup"
# Startet den Sync. Löscht Dateien in der Cloud, wenn sie lokal (Retention) geloescht wurden.
& $RcloneExe sync $SourcePath $RemotePath --transfers 4 --checkers 8 --verbose --log-file "C:\Logs\rclone_sync.log"
