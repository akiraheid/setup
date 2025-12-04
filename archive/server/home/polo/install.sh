#!/bin/bash

set -e

THIS_DIR="$(dirname "$(readlink -f "$0")")"

cd "${THIS_DIR}"

chmod -v 700 updatePoloIp.sh
mv -v updatePoloIp.sh ~/anacron/hourly/
