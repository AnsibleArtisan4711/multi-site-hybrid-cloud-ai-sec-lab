# Quelle: docs/08-ai-ops-ollama/8.5-automatisierter-feed-echtzeit-ki-analyse.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

import os
import time
import shutil
import requests
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Pfade definieren
WATCH_DIR = "/var/lib/siem-hub/windows-json/"
ARCHIVE_DIR = "/var/lib/siem-hub/analysis/archive/"
OLLAMA_URL = "http://localhost:11434/api/generate"

class LogHandler(FileSystemEventHandler):
    def on_created(self, event):
        if event.is_directory: return
        if event.src_path.endswith(".json"):
            print(f"[*] Neue Log-Datei erkannt: {event.src_path}")
            self.process_log(event.src_path)

    def process_log(self, file_path):
        with open(file_path, 'r') as f:
            content = f.read()

        # API Call an Ollama (mit Security Context aus 8.4)
        payload = {
            "model": "llama3",
            "prompt": f"Analysiere auf Brute Force oder Privilege Escalation: {content}",
            "stream": False
        }

        try:
            response = requests.post(OLLAMA_URL, json=payload)
            analysis = response.json().get('response')

            # Ergebnis sichern
            report_name = os.path.basename(file_path).replace(".json", "_report.txt")
            with open(f"/var/lib/siem-hub/analysis/{report_name}", "w") as r:
                r.write(analysis)

            # Datei archivieren
            shutil.move(file_path, os.path.join(ARCHIVE_DIR, os.path.basename(file_path)))
            print(f"[+] Analyse abgeschlossen fuer {report_name}")
        except Exception as e:
            print(f"[!] Fehler: {e}")

if __name__ == "__main__":
    if not os.path.exists(ARCHIVE_DIR): os.makedirs(ARCHIVE_DIR)
    observer = Observer()
    observer.schedule(LogHandler(), WATCH_DIR, recursive=False)
    observer.start()
    try:
        while True: time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
