# Quelle: docs/07-log-aggregation/7.5-log-formatierung-ki-readiness-strukturierung.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

# Ziel: Samba-Share auf der Kali-VM (Modul 7.4)
$Destination = "\\10.0.30.20\LogDropzone"
$FileName = "WinEvents_$(Get-Date -Format 'yyyyMMdd_HHmm').json"

# Die letzten 500 Sicherheitsereignisse strukturiert extrahieren
$Events = Get-WinEvent -LogName "ForwardedEvents" -MaxEvents 500 -ErrorAction SilentlyContinue
$StructuredData = $Events | ForEach-Object {
    [PSCustomObject]@{
        Timestamp = $_.TimeCreated; ID = $_.Id; Level = $_.LevelDisplayName;
        User = $_.UserId; Machine = $_.MachineName; Message = $_.Message
    }
} | ConvertTo-Json -Compress

# Als Datei zum Kali-Hub pushen
$StructuredData | Out-File -FilePath "$Destination\$FileName" -Encoding utf8
