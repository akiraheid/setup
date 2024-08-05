#!/bin/bash

set -e

IP_FILE="publicIp.txt"
dig +short myip.opendns.com @resolver1.opendns.com > "${IP_FILE}"
chmod -v 400 "${IP_FILE}"
rsync -v "${IP_FILE}" "ddns.heid.cc:/home/polo/${IP_FILE}"
