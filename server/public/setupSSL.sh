#!/bin/bash
# Setup SSL certs for the server domains (listed below).
# This is done separately from setupNginx.sh because the DNS has to change
# before SSL can be setup.
set -e 

# Set up SSL certs
snap install --classic certbot
[ ! -f /usr/bin/certbot ] && ln -s /snap/bin/certbot /usr/bin/certbot
certbot --nginx -d heid.cc -d ddns.heid.cc -d media.heid.cc
certbot renew --dry-run
