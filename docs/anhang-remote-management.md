# Anhang: Exkurs – Windows Server Remote Management & Admin-Tools

## Konzept: Warum Remote Management?

In der Vergangenheit loggten sich Administratoren per Remote Desktop (RDP) direkt auf Servern (wie Domain Controllern) ein, um dort Klicks in der grafischen Oberfläche auszuführen. Dies gilt in modernen Enterprise-Umgebungen als massives Sicherheitsrisiko (Credential Exposure im Arbeitsspeicher des Servers) und als ineffizient.

**Moderne Administration (The „Server Core“ Approach):** Server werden idealerweise ohne grafische Oberfläche (Server Core) betrieben oder zumindest so behandelt. Die Verwaltung erfolgt **remote** von einer sicheren Administrations-Workstation (PAW - Privileged Access Workstation) aus, wie Ihrem `CL-WIN-01`.

Dieses Dokument beleuchtet die vier zentralen Säulen der Windows Server Fernverwaltung.

## \1. WinRM & PowerShell Remoting (Die Basis)

Windows Remote Management (WinRM) ist das Microsoft-Protokoll für den Datenaustausch zwischen Rechnern. Es ist das Rückgrat für fast alle modernen Remote-Tools (inkl. Server Manager und Windows Admin Center).

### Aktivierung auf dem Ziel-Server (z. B. SRV-FS-01)

Auf Windows Servern ab Version 2016 ist WinRM standardmäßig aktiviert.

**Methode A: Per PowerShell (Empfohlen)**\
Um sicherzustellen, dass die Firewall-Regeln greifen und der Dienst lauscht, führen Sie folgenden Befehl in einer administrativen PowerShell auf dem Server aus:

**WinRM und PowerShell Remoting aktivieren**

```powershell
# Aktiviert WinRM, erstellt den Listener und oeffnet die Firewall
Enable-PSRemoting -Force
```

**Methode B: Über die grafische Oberfläche (Server Manager)**

1. Öffnen Sie den **Server-Manager** auf dem Zielserver.
2. Klicken Sie auf der linken Seite auf **Lokaler Server**.
3. Suchen Sie in den Eigenschaften den Punkt **Remoteverwaltung** und klicken Sie auf den danebenstehenden Status (Deaktiviert/Aktiviert).
4. Setzen Sie im neuen Fenster den Haken bei **Remoteverwaltung dieses Servers von anderen Computern aus zulassen** und klicken Sie auf OK.

### Spezialfall: Aktivierung auf dem Windows 11 Client

Auch Windows 11 Clients (`CL-WIN-01`) müssen oft remote vom Helpdesk verwaltet werden (z. B. um per `Enter-PSSession` Fehler im Hintergrund zu beheben, ohne die Arbeit des Benutzers zu stören).

- Führen Sie in einer administrativen PowerShell auf dem Client `Enable-PSRemoting -Force` aus.
- *Hinweis:* Wenn das Netzwerk des Clients fälschlicherweise als „Öffentlich“ statt als „Domänennetzwerk“ erkannt wird, schlägt der Befehl sicherheitshalber fehl. Nutzen Sie dann den Zusatz: `Enable-PSRemoting -SkipNetworkProfileCheck -Force`.

### Nutzung von der Workstation (CL-WIN-01)

Sie können sich nun direkt in die Konsole des Servers „einklinken“, ähnlich wie bei SSH unter Linux.

**PowerShell Remote Sessions**

```powershell
# 1. Interaktive Session oeffnen (Prompt aendert sich zu [SRV-FS-01]: PS>)
Enter-PSSession -ComputerName SRV-FS-01 -Credential ad\adm-t1-mvarga

# 2. Session wieder verlassen
Exit-PSSession

# 3. Befehl remote auf mehreren Servern gleichzeitig ausfuehren
Invoke-Command -ComputerName SRV-DC-01, SRV-FS-01 -ScriptBlock { Get-Service wuauserv }
```

## \2. RSAT (Remote Server Administration Tools)

RSAT ist die Sammlung der klassischen Microsoft Management Consoles (MMCs), wie z. B. *Active Directory-Benutzer und -Computer*, *DNS* oder *Gruppenrichtlinienverwaltung*. Anstatt diese auf dem Server zu öffnen, installieren wir sie auf dem Windows 11 Admin-Client.

### Installation auf Windows 11

Seit neueren Windows 10/11 Versionen lädt man RSAT nicht mehr als Installer herunter, sondern fügt es direkt als optionales Feature in Windows hinzu.

**Methode A: Per PowerShell (Empfohlen)**

**RSAT per PowerShell auf dem Client installieren**

```powershell
# Alle verfuegbaren RSAT-Tools auflisten
Get-WindowsCapability -Name RSAT* -Online

# Alle RSAT-Tools in einem Rutsch installieren (Dauert einige Minuten)
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
```

**Methode B: Über die grafische Oberfläche (GUI)**

1. Öffnen Sie die Windows **Einstellungen** (Tastenkombination: `Win + I`).

1. Navigieren Sie zu **System** → **Optionale Features** (in manchen Versionen unter *Apps* → *Optionale Features*).
2. Klicken Sie neben *Optionales Feature hinzufügen* auf den Button **Features anzeigen**.
3. Tippen Sie **RSAT** in die obere Suchleiste ein.
4. Setzen Sie die Haken bei allen benötigten Werkzeugen (z. B. *RSAT: Active Directory-Domänendienste...*) und klicken Sie auf **Installieren**.

### Nutzung unter Beachtung des Tier-Modells

Da Ihr normaler Windows-Login (`mvarga`) keine Rechte im Active Directory hat, dürfen Sie RSAT-Tools nicht einfach per Doppelklick starten.

1. Suchen Sie im Startmenü nach dem Tool (z. B. *Active Directory-Benutzer und -Computer*).
2. Halten Sie die **Shift-Taste** (Umschalt) gedrückt und klicken Sie mit der **rechten Maustaste** auf das Icon.
3. Wählen Sie **Als anderer Benutzer ausführen**.
4. Geben Sie die Zugangsdaten Ihres Tier-0 Admins (`adm-t0-mvarga`) ein. Das Tool öffnet sich nun lokal auf Ihrem PC, agiert aber mit den Rechten des Domain Admins auf dem DC-01.

## \3. Windows Admin Center (WAC)

Das Windows Admin Center (WAC) ist der moderne, HTML5-basierte Nachfolger des alten Server Managers und der RSAT-Tools. Es vereint Überwachung (Performance, Events), Dateiverwaltung, Zertifikate und Hyper-V Management in einer einzigen Weboberfläche.

### Architektur & Installation

WAC kann als Desktop-App (auf Win 11) oder als **Gateway** (auf einem Server) installiert werden. In Ihrem Lab empfiehlt sich die Installation als Gateway auf dem `SRV-FS-01`.

1. Laden Sie den WAC-Installer (`.msi`) von Microsoft herunter.
2. Installieren Sie ihn auf dem `SRV-FS-01`. WAC richtet dabei einen eigenen kleinen Webserver auf Port 443 ein.
3. Generieren Sie während des Setups ein selbstsigniertes SSL-Zertifikat (oder nutzen Sie eines aus Ihrer eigenen PKI).

### Die tägliche Nutzung

1. Öffnen Sie den Browser auf Ihrem Client (`CL-WIN-01`).
2. Rufen Sie `https://SRV-FS-01.ad.example.com` auf.
3. Authentifizieren Sie sich. Im WAC können Sie nun alle Server Ihrer Domäne (`SRV-DC-01`, `SRV-DC-02`) hinzufügen.

1. **Vorteile:** Sie können von hier aus Updates einspielen, Firewall-Regeln prüfen, PowerShell-Skripte im Browser ausführen und sogar Hyper-V VMs komplett verwalten, ohne jemals RDP nutzen zu müssen.

## \4. Remote Desktop Protocol (RDP)

RDP (Port 3389) ist der Klassiker, um den gesamten Desktop eines Servers auf den eigenen Bildschirm zu streamen. Wie anfangs erwähnt, sollte RDP nur noch im äußersten Notfall (Troubleshooting kaputter GUI-Anwendungen) genutzt werden.

### Aktivierung (Falls noch nicht geschehen)

Wenn ein System frisch installiert ist, ist RDP aus Sicherheitsgründen meistens deaktiviert.

**Methode A: Per PowerShell oder sconfig**\
Sie können RDP über das Server-Konfigurationstool `sconfig` (Option 7) oder per PowerShell einschalten:

**RDP aktivieren und Firewall oeffnen**

```powershell
# Aktiviert RDP in der Registry
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

# Oeffnet Port 3389 in der Windows Firewall
Enable-NetFirewallRule -DisplayGroup "Remotedesktop"
```

**Methode B: Über die grafische Oberfläche (GUI)**

- **Auf dem Windows Server:** Öffnen Sie den **Server-Manager** → *Lokaler Server*. Klicken Sie neben *Remotedesktop* auf *Deaktiviert*. Setzen Sie den Punkt auf **Remoteverbindungen mit diesem Computer zulassen**. Setzen Sie zwingend den Haken für NLA (Authentifizierung auf Netzwerkebene) und bestätigen Sie mit OK.
- **Auf dem Windows 11 Client (Für Helpdesk-Zugriff):** Öffnen Sie die **Einstellungen** (Tastenkombination Win + I) → **System** → **Remotedesktop**. Stellen Sie den Schalter auf **Ein** und bestätigen Sie die Warnmeldung, dass der PC nun remote erreichbar ist.

> [!NOTE]
> **Portfolio-Fazit: Die PAW-Strategie (Privileged Access Workstation)**\
> Dokumentieren Sie in Ihrem Bericht, dass Sie den administrativen Zugriff strikt strukturieren. Anstatt von einem unsicheren privaten PC per RDP auf einen Domain Controller zu springen, verwalten Sie die Systeme via WinRM, RSAT und WAC von einer gehärteten Tier-2 Workstation aus. Dies reduziert die Angriffsfläche massiv. Alle Verwaltungsprotokolle (WinRM Port 5985, WAC Port 443) sind vollständig verschlüsselt und können (durch OPNsense) strikt auf bestimmte Quell-IPs (z. B. nur Ihren Admin-Client) limitiert werden.

> [!IMPORTANT]
> **Sicherheits-Tipp für WinRM (TrustedHosts):**
>
> befinden, nutzt WinRM standardmäßig die sichere Kerberos-Authentifizierung. Eine Konfiguration von `TrustedHosts` (was oft in Tutorials für Arbeitsgruppen/Workgroups empfohlen wird) ist hier **nicht erforderlich** und sollte aus Sicherheitsgründen vermieden werden.

Da sich in Ihrem Lab alle Windows-Rechner innerhalb der Active Directory Domäne (`ad.example.com`)
