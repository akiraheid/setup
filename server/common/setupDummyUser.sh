#!/bin/bash
set -e

echo "Creating dummy user"
# Creates user with a random password
PASS=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 30)
PASS=$(perl -e 'print crypt($ARGV[0], "password")' $PASS)
groupadd dummy
useradd --no-create-home -g dummy -p $PASS dummy
echo "Creating dummy user - Done"
