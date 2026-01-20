#!/bin/bash

################################################################################
# SCRIPT NAME:    spdyn_updater.sh
# BESCHREIBUNG:   Dynamisches DNS Update für spDYN (Securepoint) mit IPv4/IPv6.
#                 Vergleicht lokale IP mit aktueller IP vor dem Update (Anti-Flood).
# AUTOR:          timiwho
# GITHUB:         https://github.com/dein-benutzername/projektname
#
# SETUP:          1. Erstelle eine Datei 'spdns.conf' im selben Verzeichnis.
#                 2. Trage dort HOSTNAME, USER und PASS ein (siehe README).
#                 3. chmod 700 spdyn_updater.sh && chmod 600 spdns.conf
################################################################################

# --- PFADE ---
VERZEICHNIS="$(cd "$(dirname "$0")" && pwd)"
CONF_DATEI="$VERZEICHNIS/spdns.conf"
DATEI_V4="$VERZEICHNIS/IP4.txt"
DATEI_V6="$VERZEICHNIS/IP6.txt"
LOGDATEI="$VERZEICHNIS/spdyn.log"

# --- LADE KONFIGURATION ---
if [ -f "$CONF_DATEI" ]; then
    source "$CONF_DATEI"
else
    echo "$(date) - Fehler: Konfigurationsdatei $CONF_DATEI nicht gefunden!"
    exit 1
fi

# --- LOG-EINSTELLUNGEN ---
MAX_LOG_SIZE=500
MAX_OLD_LOGS=3
JETZT=$(date "+%Y-%m-%d %H:%M:%S")

# --- LOG-ROTATION ---
if [ -f "$LOGDATEI" ]; then
    SIZE_KB=$(du -k "$LOGDATEI" | cut -f1)
    if [ "$SIZE_KB" -ge "$MAX_LOG_SIZE" ]; then
        [ -f "$LOGDATEI.$MAX_OLD_LOGS" ] && rm "$LOGDATEI.$MAX_OLD_LOGS"
        for ((i=MAX_OLD_LOGS-1; i>=1; i--)); do
            [ -f "$LOGDATEI.$i" ] && mv "$LOGDATEI.$i" "$LOGDATEI.$((i+1))"
        done
        mv "$LOGDATEI" "$LOGDATEI.1"
        echo "[$JETZT] Log rotiert." > "$LOGDATEI"
    fi
fi

# --- IP ABFRAGE & BEREINIGUNG ---
NEUE_V4=$(curl -s -4 https://ifconfig.me | tr -d '\n\r ')
NEUE_V6=$(curl -s -6 https://ifconfig.me 2>/dev/null | tr -d '\n\r ')
[ -z "$NEUE_V6" ] && NEUE_V6="none"

ALTE_V4=$(cat "$DATEI_V4" 2>/dev/null | tr -d '\n\r ')
ALTE_V6=$(cat "$DATEI_V6" 2>/dev/null | tr -d '\n\r ')

# --- ANTI-FLUT LOGIK ---
if [ -z "$NEUE_V4" ]; then
    echo "[$JETZT] Fehler: IPv4 konnte nicht ermittelt werden." >> "$LOGDATEI"
    exit 1
fi

if [ "$NEUE_V4" != "$ALTE_V4" ] || [ "$NEUE_V6" != "$ALTE_V6" ]; then
    if [ "$NEUE_V6" != "none" ]; then
        IP_PARAM="$NEUE_V4,$NEUE_V6"
    else
        IP_PARAM="$NEUE_V4"
    fi

    # Update senden
    RESPONSE=$(curl -s "https://update.spdyn.de/nic/update?hostname=$HOSTNAME&myip=$IP_PARAM&user=$USER&pass=$PASS")

    echo -n "$NEUE_V4" > "$DATEI_V4"
    echo -n "$NEUE_V6" > "$DATEI_V6"
    echo "[$JETZT] IP GEÄNDERT! Neu: $IP_PARAM -> Server: $RESPONSE" >> "$LOGDATEI"
else
    echo "[$JETZT] Keine Änderung. (IP: $NEUE_V4). Überspringe Update." >> "$LOGDATEI"
fi
