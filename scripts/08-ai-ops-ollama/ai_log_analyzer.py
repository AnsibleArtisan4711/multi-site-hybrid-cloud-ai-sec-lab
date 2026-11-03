# Quelle: docs/08-ai-ops-ollama/8.3-python-api-anbindung-automatisierte-analyse.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

import requests
import json
import os

# Konfiguration
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "llama3"
LOG_DIR = "/var/lib/siem-hub/windows-json/"
OUTPUT_DIR = "/var/lib/siem-hub/analysis/"

def analyze_logs(log_data):
    # System-Prompt definieren fuer bessere KI-Antworten
    prompt = f"Du bist ein Cyber-Security Analyst. Analysiere folgende Windows-Logdaten im JSON-Format auf Anomalien oder Angriffszeichen (z.B. Brute Force, unbefugte Admin-Erstellung). Antworte kurz und praezise: \n\n {log_data}"
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False # Wir wollen die Antwort als einen Block
    }

    try:
        response = requests.post(OLLAMA_URL, json=payload)
        return response.json().get('response', 'Fehler in der Antwort.')
    except Exception as e:
        return f"API-Verbindungsfehler: {str(e)}"

# Hauptschleife: Scanne Dateien
for file in os.listdir(LOG_DIR):
    if file.endswith(".json"):
        with open(os.path.join(LOG_DIR, file), 'r') as f:
            data = f.read()
            print(f"Analysiere Datei: {file}...")
            result = analyze_logs(data)

            # Ergebnis speichern
            output_file = f"Analysis_{file.replace('.json', '.txt')}"
            with open(os.path.join(OUTPUT_DIR, output_file), 'w') as out:
                out.write(result)
            print(f"Ergebnis gesichert in {output_file}")
