#!/bin/bash

. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

echo "Installing npm..."
if [ ! -z `which npm` ]; then
	echo "Done"
	exit 0
fi

_install curl
curl -fsS -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
$(nvm install node)
echo "Done"
exit 0
