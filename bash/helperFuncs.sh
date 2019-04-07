#!/bin/bash

if [ -z $DATE ]; then
	DATE=`date +%Y%m%d-%H%M%S`
fi

function _install() {
	if [ -z `which $1` ]; then
		sudo apt-get install -y $1
	fi
}

function _backupInstall() {
	SETUP="${SETUP_DIR}/bash/$1"
	THING="${HOME}/$1"
	BACKUP="${HOME}/$1.bak-${DATE}"
	echo "Installing ${SETUP}..."
	if [[ -e ${THING} || -h ${THING} ]]; then
		echo "  ${THING} exists. Creating backup: ${BACKUP}"
		cp ${THING} ${BACKUP} > /dev/null 2>&1
		rm ${THING}
	fi
	echo "  Creating symlink to ${SETUP}"
	ln -s ${SETUP} ${THING}
}
