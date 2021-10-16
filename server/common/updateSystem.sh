#!/bin/bash
set -e

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
