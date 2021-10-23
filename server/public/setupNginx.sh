#!/bin/bash
set -e

apt-get install -y podman nginx

pushd nginx
toDir=/etc/nginx/sites-available
cp default.conf $toDir/default
cp heid.cc.conf $toDir/heid.cc
cp ddns.heid.cc.conf $toDir/ddns.heid.cc
popd

pushd /etc/nginx/sites-enabled
[ ! -f default ] && ln -s $toDir/default default
[ ! -f heid.cc ] && ln -s $toDir/heid.cc heid.cc
[ ! -f ddns.heid.cc ] && ln -s $toDir/ddns.heid.cc ddns.heid.cc
popd

# Create site directories
mkdir -p /var/www
pushd /var/www
mkdir -p heid.cc ddns.heid.cc
chmod -R 755 *
popd

cp index.html /var/www/heid.cc/index.html
cp index.html /var/www/ddns.heid.cc/index.html
nginx -t
systemctl restart nginx

snap install --classic certbot
[ ! -f /usr/bin/certbot ] && ln -s /snap/bin/certbot /usr/bin/certbot
certbot --nginx
certbot renew --dry-run
