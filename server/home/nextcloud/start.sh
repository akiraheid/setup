#!/bin/bash
set -e

function dt() {
	date +%FT%T
}

scriptdir=`dirname $(readlink -f $0)`
podname=nextcloud

if podman pod exists $podname ; then
	state=`podman pod ps -a | grep $podname | sed 's/\s\+/ /g' | cut -d ' ' -f 3`

	if [ "$state" != "Running" ]; then
		podman pod rm -f $podname
	fi
fi

podman play kube $scriptdir/deployment.yaml

#echo "Cleaning up pod..."
#POD=nextcloud
#podman pod exists $POD && podman pod rm -f $POD
#echo "Cleaning up pod... done"
#
#echo "Create missing volumes..."
#main=nextcloud-main
#config=nextcloud-config
#custom_apps=nextcloud-custom_apps
#db=nextcloud-db
#podman volume exists $main || podman volume create $main
#podman volume exists $config || podman volume create $config
#podman volume exists $custom_apps || podman volume create $custom_apps
#podman volume exists $db || podman volume create $db
#echo "Create missing volumes... done"
#
## Start the pod, updating images, if available
#echo "Create pod..."
#podman pod create --name $POD -p 8081:80
#
#echo "Create nextcloud container..."
#podman run --rm -d --pod $POD --name nextcloud-nextcloud \
#	--env-file ~/nextcloud.env \
#	--replace \
#	--restart on-failure \
#	--umask 0012 \
#	-v $main:/var/www/html:Z \
#	-v $config:/var/www/html/config:Z \
#	-v $custom_apps:/var/www/html/custom_apps:Z \
#	-v /raid/nextcloud/storage:/var/www/html/data:Z \
#	docker.io/library/nextcloud:25
#echo "Create nextcloud container... done"
#
#echo "Create mariadb container..."
#podman run --rm -d --pod $POD --name nextcloud-mariadb \
#	--env-file ~/mariadb.env \
#	--replace \
#	--restart on-failure \
#	-v $db:/var/lib/mysql \
#	docker.io/library/mariadb:10
#echo "Create mariadb container... done"
#
## Clean up old images
#podman image prune -f
