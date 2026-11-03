# Multi-Site Hybrid Cloud & AI-Sec Operations

Praxisorientierte Übungen und Mini-Projekte für den Aufbau eines **Enterprise-Grade Homelabs**: zwei Standorte, Active Directory, OPNsense, Hybrid Identity mit Microsoft 365, zentrale Log-Auswertung mit lokaler KI (Ollama), Security Audits sowie Backup und Disaster Recovery.

Autor: **AnsibleArtisan4711** (Pseudonym)

## Szenario

- **Host 1 (HQ):** 4TB SSD, 40GB RAM. VMs: OPNsense, DC1, Win-Client, Ubuntu-Client, DMZ (Apache).
- **Host 2 (Filiale):** 2TB SSD, 40GB RAM. VMs: OPNsense, DC2, Kali Linux (Ollama).
- **Storage:** 40TB HDD NAS, 2TB NVMe Cache, 256GB SD-Card.
- **Cloud:** 1TB M365 Business Basic, 5TB Google One.
- **Domain:** ad.example.com (lokal) / example.com (extern/Cloud).

## Module

| Modul | Titel | Inhalt |
| --- | --- | --- |
| 0 | [Mission Control (Strategie & Architektur)](docs/00-mission-control/README.md) | Bevor die erste VM startet, muss der Bauplan stehen. Dies ist dein architektonisches Fundament. |
| 1 | [Virtualisierung & Storage-Meisterschaft](docs/01-virtualisierung-storage/README.md) | Das physische Fundament und dein massiver Datenspeicher werden vorbereitet. |
| 2 | [Standortvernetzung & Routing (OPNsense)](docs/02-standortvernetzung-routing/README.md) | Die zwei isolierten Rechner werden zu einem logischen Unternehmensnetzwerk verbunden. |
| 3 | [Multi-Site Active Directory](docs/03-multi-site-active-directory/README.md) | Das Herzstück der Authentifizierung wird über beide Standorte repliziert. |
| 4 | [Die virtuelle DMZ & Web-Hosting](docs/04-dmz-web-hosting/README.md) | Dein Test-Webserver wird sicher vom restlichen Firmennetz isoliert. |
| 5 | [Windows & Linux Client Integration](docs/05-client-integration/README.md) | Endgeräte werden in die Domäne aufgenommen und zentral verwaltet. |
| 6 | [Hybrid Identity & Microsoft 365](docs/06-hybrid-identity-m365/README.md) | Die Brücke zwischen lokaler Kontrolle und der Cloud wird gebaut. |
| 7 | [Log-Aggregation & Event Management](docs/07-log-aggregation/README.md) | Vorbereitung für die KI: Alle Systemdaten an einem zentralen Ort sammeln. |
| 8 | [AI Ops – Log-Analyse mit Ollama (Highlight)](docs/08-ai-ops-ollama/README.md) | Einsatz von lokaler KI zur Erkennung von Sicherheitsvorfällen. |
| 9 | [Security Audits & Penetration Testing](docs/09-security-audits-pentesting/README.md) | Das System auf Herz und Nieren prüfen – "Hack yourself first". |
| 10 | [Backup & Disaster Recovery (3-2-1-0)](docs/10-backup-disaster-recovery/README.md) | Der Rettungsschirm für das gesamte Unternehmen. |
| 11 | [M365 Business Basic Deep Dive](docs/11-m365-deep-dive/README.md) | Ausreizen der Cloud-Features für die tägliche Administration. |
| 12 | [Dokumentation, Lifecycle & Übergabe](docs/12-dokumentation-uebergabe/README.md) | Der Abschluss eines jeden IT-Projekts: Was nicht dokumentiert ist, existiert nicht. |
| Anhang | [Exkurs: Windows Server Remote Management](docs/anhang-remote-management.md) | Admin-Tools und Remote-Zugriff |

Jedes Modul besteht aus sieben Steps. Die Skripte liegen zusätzlich als eigene Dateien im Ordner [`scripts/`](scripts/README.md).

## Repository-Struktur

```text
docs/        Dokumentation je Modul (ein Markdown-File pro Step)
scripts/     Skripte aus den Übungen (Python, PowerShell)
```

## Hinweise zu Daten und Sicherheit

> [!IMPORTANT]
> Alle Domänen (`example.com`, `contoso`), Benutzernamen und E-Mail-Adressen sind **Platzhalter**. Die IP-Adressen stammen aus privaten Bereichen (RFC 1918) der Lab-Umgebung. Es sind keine echten Zugangsdaten enthalten. Bitte auch in Forks und Pull Requests keine Passwörter, Tokens, Schlüssel oder Webhook-URLs committen.

> [!WARNING]
> Die Security-Übungen (Modul 9) sind nur in der eigenen, isolierten Lab-Umgebung zulässig.

## Lizenz

Dokumentation: [CC BY 4.0](LICENSE-DOCS.md). Skripte: [MIT](LICENSE).
