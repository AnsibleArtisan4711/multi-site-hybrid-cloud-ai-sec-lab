# Quelle: docs/07-log-aggregation/7.7-datenbereinigung-noise-filtering-ai-ready-data.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

import pandas as pd

# CSV einlesen (erstellt in Modul 7.5)
log_file = "/var/lib/siem-hub/syslog/network_structured.csv"
df = pd.read_csv(log_file, sep=';', names=['Timestamp', 'Host', 'Service', 'Message'])

# 1. Bekannte harmlose Services entfernen (z.B. NTP-Sync)
filtered_df = df[~df['Message'].str.contains('ntp|time-sync', case=False)]

# 2. Identische aufeinanderfolgende Meldungen zaehlen (Deduplizierung)
# Verhindert, dass 1000 "Connection Denied" Zeilen die KI fluten
df_grouped = filtered_df.groupby(['Host', 'Message']).size().reset_index(name='Occurrences')

# 3. Bereinigte Daten fuer die KI speichern
df_grouped.to_json("/var/lib/siem-hub/analysis/cleaned_batch.json", orient='records')
