#!/bin/bash

. ${SETUP_DIR}/bash/helperFuncs.sh
ERR=$?
if [ "$ERR" != "0" ]; then
	exit 1
fi

_install curl

echo "Installing Tor..."
TOR_VERSION=8.0.1
TOR_URL="https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz"
ZIPPED_TOR="~/tmp/tor-browser-${TOR_VERSION}.tar.xz"
UNZIPPED_TOR="~/Download/tor-browser"

mkdir -p $UNZIPPED_TOR "~/tmp"
curl -fsS -o $ZIPPED_TOR $TOR_URL && tar -xzf $ZIPPED_TOR $UNZIPPED_TOR
rm $ZIPPED_TOR
echo "Done"
exit 0
