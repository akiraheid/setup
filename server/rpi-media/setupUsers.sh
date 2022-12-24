#!/bin/bash
# Set up RaspberryPi users
#
# The default user is expected to be named "guest"

set -e

if [ -z "$(grep -e '^guest:')" ]; then
	echo "Missing user 'guest'. Format RPi to make 'guest' default user."
	exit 1
fi

if [ -z "$(grep -e '^admin:' /etc/passwd)" ]; then
	echo "Setting up admin user..."
	adduser --system --gecos GECOS --ingroup sudo admin
	echo "Setting up admin user... done"
fi

deluser guest sudo
