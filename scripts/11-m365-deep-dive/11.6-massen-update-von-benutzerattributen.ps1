# Quelle: docs/11-m365-deep-dive/11.6-powershell-fuer-m365-ms-graph-automatisierung.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

# 1. Alle Benutzer abfragen, bei denen der Verwendungsstandort leer ist
$UsersWithoutLocation = Get-MgUser -All | Where-Object { [string]::IsNullOrEmpty($_.UsageLocation) }

# 2. Schleife starten und jeden Benutzer anpassen
foreach ($User in $UsersWithoutLocation) {
    Write-Host "Setze Standort 'AT' fuer $($User.DisplayName)..."
    Update-MgUser -UserId $User.Id -UsageLocation "AT"
}

Write-Host "Massen-Update abgeschlossen."
