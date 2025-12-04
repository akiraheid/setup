#!/bin/bash

. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

echo "Installing eslint..."
if [ -z `which eslint` ]; then
	if [ -z `which npm` ]; then
		(. ${SETUP_DIR}/bash/installnpm.sh)
	fi

	npm i -g eslint
fi
echo "Done"
exit 0
