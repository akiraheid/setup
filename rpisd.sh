#!/usr/bin/env sh
# Configure an Raspberry Pi SD card to:
# - Enable SSH server on boot
# - Create a default user

touch ssh
pass=$(echo "changeme123" | openssl passwd -6 -stdin)
echo "pi:$pass" >> userconf.txt
