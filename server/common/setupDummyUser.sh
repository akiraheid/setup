#!/bin/bash
# Create a user with a random password.
# Generally helpful to run services to prevent privilege escalation 
# in the case of container/pod breakout.
set -e

USERNAME=dummy

if [ -n "$1" ]; then
	USERNAME="$1"
fi

if id $USERNAME &>/dev/null; then
	echo "User $USERNAME already exists"
	exit 0
else
	echo "Creating user $USERNAME"
fi

# Creates user with a random password
PASS=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 30)
PASS=$(perl -e 'print crypt($ARGV[0], "password")' $PASS)

groupadd $USERNAME
useradd --create-home --home-dir /home/$USERNAME -g $USERNAME -p $PASS $USERNAME
echo "Creating user $USERNAME - Done"
