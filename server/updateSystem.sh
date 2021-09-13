#!/bin/bash
# Update the system

set -e

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove

reboot now
