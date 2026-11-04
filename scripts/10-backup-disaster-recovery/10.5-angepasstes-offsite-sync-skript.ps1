# Quelle: docs/10-backup-disaster-recovery/10.5-backup-copy-job-cloud-verschluesselung.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

$RcloneExe = "C:\rclone\rclone.exe"
# Pfad auf die 14TB Platte (Secondary Repo mit den verschluesselten Copy-Jobs)
$SourcePath = "A:\VeeamBackups\COPY-To-Secondary-Encrypted\"
$RemotePath = "GDrive:Veeam_Offsite_Backup"

# Archivordner mit Datum fuer lokal geloeschte oder geaenderte Dateien
$ArchivePath = "GDrive:Veeam_Offsite_Archiv/" + (Get-Date -Format "yyyy-MM-dd")
# Sync starten (lokal geloeschte oder geaenderte Dateien werden in den Archivordner verschoben)
& $RcloneExe sync $SourcePath $RemotePath --backup-dir $ArchivePath --transfers 4 --checkers 8 --verbose --log-file "C:\Logs\rclone_sync.log"
