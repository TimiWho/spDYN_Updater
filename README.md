# 🌐 spDYN Dynamic DNS Updater

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%2F%20Raspberry%20Pi-BC1141?style=flat-square&logo=raspberry-pi&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

Ein Bash-Script zur automatischen Aktualisierung von IPv4- und IPv6-Adressen für den Dienst **spDYN (Securepoint)**. Entwickelt für maximale Zuverlässigkeit bei minimaler Systemlast auf dem Raspberry Pi.

---

## ✨ Features

- **Dual-Stack Support:** Kombiniertes Update von IPv4 und IPv6 in einem Request.
- **Anti-Flood:** Ein Update erfolgt nur bei tatsächlicher IP-Änderung durch lokalen Cache-Abgleich.
- **String-Sanitization:** Automatische Bereinigung von unsichtbaren Steuerzeichen (`\n`, `\r`) für präzisen Vergleich.
- **Integriertes Log-Management:**
  - Protokollierung aller Vorgänge in `spdyn.log`.
  - **Log-Rotation:** Begrenzung auf 500KB (einstellbar).
  - **Archivierung:** Ältere Logs werden automatisch verschoben (`.log.1`, `.log.2` etc.).
- **Sichere Architektur:** Trennung von Programmlogik und privaten Zugangsdaten.

---

## 🛠️ Installation & Konfiguration

### 1. Projektverzeichnis erstellen
```bash
mkdir -p ~/scripts/spdns_updater
cd ~/scripts/spdns_updater

```

### 2. Konfigurationsdatei anlegen

Erstelle eine Datei namens `spdns.conf`. Diese Datei enthält deine privaten Zugangsdaten und wird vom Script eingelesen. **Diese Datei darf nicht auf GitHub hochgeladen werden!**

```bash
cat <<EOF > spdns.conf
# spDYN Zugangsdaten
HOSTNAME="dein-host.spdns.eu"
USER="dein-benutzername"
PASS="dein-update-token-oder-passwort"
EOF

```

### 3. Sicherheit & Rechte setzen

Stelle sicher, dass nur dein Benutzer das Script und die Passwörter lesen kann:

```bash
chmod 700 spdyn_updater.sh
chmod 600 spdns.conf

```

---

## 🚀 Automatisierung (Cronjob)

Um die IP-Adressen automatisch aktuell zu halten, sollte das Script regelmäßig im Hintergrund laufen.

1. **Crontab öffnen:**
```bash
crontab -e

```


2. **Cron-Regel hinzufügen:**
Füge diese Zeile am Ende der Datei ein (Prüfung alle 5 Minuten):
```cron
*/5 * * * * /home/YOUR_USER/scripts/spdns_updater/spdyn_updater.sh

```


*(Hinweis: Ersetze `/home/YOUR_USER/...` durch den echten Pfad zu deinem Script.)*

---

## 📂 Dateistruktur

Nach dem ersten Start sieht dein Verzeichnis wie folgt aus:

| Datei | Typ | Beschreibung |
| --- | --- | --- |
| `spdyn_updater.sh` | Script | Das ausführbare Hauptprogramm |
| `spdns.conf` | Config | **Privat:** Deine spDYN Zugangsdaten |
| `IP4.txt` | Cache | Speichert die zuletzt bekannte IPv4 |
| `IP6.txt` | Cache | Speichert die zuletzt bekannte IPv6 |
| `spdyn.log` | Log | Aktuelles Protokoll der Update-Vorgänge |
| `spdyn.log.x` | Archiv | Rollierende Log-Archive (Rotation) |

---

## ⚠️ GitHub Sicherheit (.gitignore)

Um deine privaten Daten zu schützen, erstelle eine `.gitignore` Datei in diesem Ordner:

```text
# .gitignore
spdns.conf
IP4.txt
IP6.txt
*.log*

```

---

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert.
