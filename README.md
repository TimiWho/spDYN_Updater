# spDYN_Updater

[Kurze Änderungsübersicht](AENDERUNGEN_README_2026-10-21.md)

## 🚀 spDYN-Updater – IPv4/IPv6 und lokale Statusdateien

![Plattform](https://img.shields.io/badge/Plattform-Linux%20/%20Bash-blue) ![Schnittstelle](https://img.shields.io/badge/Schnittstelle-HTTPS%20/%20DNS-orange)

Bash-Skript zur Aktualisierung eines spDYN-DNS-Namens. Es ermittelt öffentliche Adressen, vergleicht sie mit lokal gespeicherten Werten und sendet bei Änderung einen Updateaufruf.

**Dokumentationsstand:** 21.10.2026 · Branch `master`. Beschreibt den vorhandenen Projektstand; kein neuer Funktionstest am Gerät.

[Quellcode herunterladen](https://github.com/TimiWho/spDYN_Updater/archive/refs/heads/master.zip) · [Ursprüngliche Haupt-README](README_Backup_2026-10-21.md)

---

## 🔌 Eingaben, Ausgaben und Parameter

| Bezeichner / Datei | Bedeutung |
| --- | --- |
| code/spdyn_updater.sh | Aktiver Skriptpfad. |
| spdns.conf | Wird relativ zum Skriptverzeichnis geladen; enthält HOSTNAME, USER und PASS. |
| IP4.txt / IP6.txt | Zuletzt lokal gespeicherte Adressen. |
| spdyn.log | Protokoll im Skriptverzeichnis. |
| MAX_LOG_SIZE=500 | Rotationsgrenze in KiB gemäß du -k. |
| MAX_OLD_LOGS=3 | Drei rotierte Protokolldateien. |
| NEUE_V6=none | Fallback bei fehlender öffentlicher IPv6. |

## ⚙️ Tatsächlicher Ablauf und Einrichtung

IPv4 ist erforderlich; bei leerer IPv4 endet das Skript mit Fehler. Bei veränderter IPv4 oder IPv6 werden die vorhandenen Adressen übertragen, andernfalls nur ein Logeintrag geschrieben.

Der Code speichert die neuen Adressen **nach dem Updateaufruf unabhängig vom Inhalt der Serverantwort**. Die Statusdateien beweisen somit keinen bestätigten DNS-Updateerfolg. Die Serverantwort steht im Log.

Das Skript läuft einmalig und besitzt keinen eigenen Endlos-Timer. Regelmäßige Aufrufe entstehen durch einen externen Cronjob; der bisherige Cronvorschlag bleibt eine Konfigurationsanleitung. Benötigt werden Bash, curl und die verwendeten Standardprogramme. `chmod 700` für das Skript und `chmod 600` für die Konfigurationsdatei wie in der ursprünglichen Anleitung setzen.

## 🐞 GitHub-Issues

**Abgleich:** 21.10.2026. Status aus GitHub; diese Übersicht ändert keine Issues.

Zum Abgleichzeitpunkt sind keine offenen GitHub-Issues vorhanden.

In diesem Repository sind zum Abgleichzeitpunkt keine GitHub-Issues vorhanden.

## 🗂️ Ursprüngliche Projektdokumentation

Die ursprünglichen technischen Erläuterungen, Quellenangaben und Autorenhinweise bleiben nachfolgend erhalten. Maßgeblich für konkrete Pin- und Timerwerte ist der oben beschriebene Repository-Stand.

<details>
<summary>Ursprüngliche Projektdokumentation anzeigen</summary>

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
Konkrete Zugangswerte werden lokal in der jeweiligen Konfiguration festgelegt.
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


</details>

