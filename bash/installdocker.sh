#!/bin/bash

. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

_install curl

echo "Installing Docker..."
if [ ! -z `which docker` ]; then
	echo "Done"
	exit 0
fi

sudo apt-get remove -y docker docker-engine docker.io
echo "  Install dependencies"
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common
echo "  Add docker repository"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
echo "  Install docker"
sudo apt-get update; sudo apt-get install -y docker-ce;
echo "  Test docker"
sudo docker run hello-world
echo "Done"
exit 0
