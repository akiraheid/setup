#!/bin/bash
set -e

apt-get install -y nginx

# Create site directories
mkdir -p /var/www
pushd /var/www
mkdir -p heid.cc ddns.heid.cc media.heid.cc
chmod -R 755 *
popd

pushd nginx
toDir=/etc/nginx/sites-available
cp default.conf $toDir/default
cp heid.cc.conf $toDir/heid.cc
cp ddns.heid.cc.conf $toDir/ddns.heid.cc
cp media.heid.cc.conf $toDir/media.heid.cc

cp index.html /var/www/heid.cc/index.html
cp index.html /var/www/ddns.heid.cc/index.html
cp index.html /var/www/media.heid.cc/index.html
popd

pushd /etc/nginx/sites-enabled
[ ! -f default ] && ln -s $toDir/default default
[ ! -f heid.cc ] && ln -s $toDir/heid.cc heid.cc
[ ! -f ddns.heid.cc ] && ln -s $toDir/ddns.heid.cc ddns.heid.cc
[ ! -f media.heid.cc ] && ln -s $toDir/media.heid.cc media.heid.cc
popd

nginx -t
systemctl restart nginx

# Install DDNS proxy updater
cp updateNginxProxy.sh /etc/cron.hourly/
