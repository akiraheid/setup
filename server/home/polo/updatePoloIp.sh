#!/bin/bash

set -e

IP_FILE="publicIp.txt"
dig +short myip.opendns.com @resolver1.opendns.com > "${IP_FILE}"
chmod 400 "${IP_FILE}"
rsync "${IP_FILE}" "ddns.heid.cc:/home/polo/${IP_FILE}"
