#!/bin/bash

echo "Installing vim..."
. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

_install vim
_backupInstall ".vimrc"
echo "Done"
exit 0
