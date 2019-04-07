#!/bin/bash

. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

if [ -z ${VIM_BUNDLE_DIR} ]; then
	VIM_BUNDLE_DIR="${HOME}/.vim/bundle"
fi

if [ -z ${INSTALLED_PATHOGEN} ]; then
	(. ${SETUP_DIR}/bash/installpathogen.sh)
fi

echo "Installing syntastic..."
if [ ! -d "${VIM_BUNDLE_DIR}/syntastic" ]; then
	mkdir -p ${VIM_BUNDLE_DIR}
	git clone --depth=1 https://github.com/scrooloose/syntastic.git $VIM_BUNDLE_DIR/syntastic
fi
echo "Done"
exit 0
