# Quelle: docs/07-log-aggregation/7.7-datenbereinigung-noise-filtering-ai-ready-data.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

# Bekannte Rausch-IDs definieren (Beispiele)
# 4662: Zugriff auf Verzeichnisdienst-Objekt (sehr haeufig)
# 5156: Windows Filtering Platform erlaubte Verbindung
$NoiseIDs = @(4662, 5156, 5158)

$Events = Get-WinEvent -LogName "ForwardedEvents" -MaxEvents 1000
$CleanEvents = $Events | Where-Object { $NoiseIDs -notcontains $_.Id }

$StructuredData = $CleanEvents | ForEach-Object {
    [PSCustomObject]@{
        Time = $_.TimeCreated; ID = $_.Id;
        User = $_.UserId; Msg = ($_.Message -split "\r?\n")[0] # Nur erste Zeile der Meldung
    }
} | ConvertTo-Json -Compress
