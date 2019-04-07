#!/bin/bash

. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

if [ -z ${INSTALLED_VIM} ]; then
	(. ${SETUP_DIR}/bash/installvim.sh)
fi

echo "Installing pathogen..."
PATHOGEN="${HOME}/.vim/autoload/pathogen.vim"
if [ -f ${PATHOGEN} ]; then
	echo "Done"
	exit 0
fi

_install curl
mkdir -p ~/.vim/autoload
curl -fsS https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -o ${PATHOGEN}
echo "Done"
exit 0
