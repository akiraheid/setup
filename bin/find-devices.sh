#!/usr/bin/env bash
#
# newdev.sh - find devices that appeared on the network between two nmap scans
#
# Usage: ./newdev.sh [cidr]   e.g. ./newdev.sh 192.168.1.0/24
#        If no CIDR is given, it is auto-detected from the default route.

set -u

# --- helper: indent every line of stdin by two spaces --------------------------
indent() {
    while IFS= read -r line; do
        echo "  ${line}"
    done
}

# --- verify nmap exists ---------------------------------------------------------
if ! command -v nmap >/dev/null 2>&1; then
    echo "ERROR: nmap is not installed."
    echo "  Debian/Ubuntu: sudo apt install nmap"
    echo "  Arch:          sudo pacman -S nmap"
    echo "  Fedora:        sudo dnf install nmap"
    exit 1
fi

# --- auto-detect subnet if not provided ------------------------------------------
if [ $# -ge 1 ]; then
    CIDR="$1"
else
    PREFIX=$(ip -o addr show scope global |
             grep -oP '\d+\.\d+\.\d+\.\d+/\d+' | head -n1)
    if [ -z "$PREFIX" ]; then
        echo "ERROR: could not auto-detect subnet. Pass a CIDR, e.g.:"
        echo "  $0 192.168.1.0/24"
        exit 1
    fi
    CIDR="$PREFIX"
fi

echo "Scanning network: ${CIDR}"

# --- scan function: emits "<ip>|<mac>" per live host ------------------------------
run_scan() {
    sudo nmap -sn -PR -T4 "${CIDR}" -oG - 2>/dev/null |
	awk '
        function flush_host() {
            if (ip != "") print ip "|" mac "|" hn
        }
        /Status: Up/ {
            flush_host()
            ip = $2
            hn = $3
            gsub(/[()]/, "", hn)
            mac = ""
            next
        }
        /MAC Address:/ {
            mac = $3
            sub(/,$/, "", mac)
        }
        END { flush_host() }
    ' | sort -u
}

# --- first scan -------------------------------------------------------------------
echo "Running first scan..."
SCAN1=$(run_scan)

HOSTCOUNT1=$(echo "${SCAN1}" | grep -c . || true)
echo "First scan found: ${HOSTCOUNT1} device(s)"
echo "${SCAN1}" | indent

# --- pause -------------------------------------------------------------------------
echo
read -r -p "Power on / wake your target device now, then press ENTER to rescan... "

# --- second scan --------------------------------------------------------------------
echo "Running second scan..."
SCAN2=$(run_scan)

HOSTCOUNT2=$(echo "${SCAN2}" | grep -c . || true)
echo "Second scan found: ${HOSTCOUNT2} device(s)"

# --- diff ----------------------------------------------------------------------------
OLD_IPS=$(echo "${SCAN1}" | cut -d'|' -f1 | sort -u)

NEW_IPS=$(echo "${SCAN2}" | cut -d'|' -f1 | sort -u |
          comm -23 - <(echo "${OLD_IPS}"))

echo
echo "==============================================="
echo "New devices detected in second scan:"
echo "==============================================="
if [ -z "${NEW_IPS}" ]; then
    echo "(none found)"
    echo
    echo "Hints:"
    echo "  - The device may have already been online during scan 1."
    echo "  - Some devices cache ARP slowly; run the script again."
    echo "  - Try widening the range: $0 192.168.0.0/24"
else
    echo "${NEW_IPS}" | while read -r NIP; do
        MAC=$(echo "${SCAN2}" | awk -F'|' -v ip="${NIP}" '$1==ip {print $2; exit}')
        if [ -n "${MAC}" ]; then
            echo "  IP: ${NIP} MAC: ${MAC}"
        else
            echo "  IP: ${NIP} MAC: (unknown)"
        fi
    done
fi
echo "==============================================="
