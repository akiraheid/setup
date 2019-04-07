#!/bin/bash

. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

_backupInstall ".bashrc"
_backupInstall ".profile"
_backupInstall ".bash_profile"

echo "Done. Restart the system for the changes to take effect"
exit 0
