#!/bin/bash

set -e

THIS_DIR="$(dirname $(readlink -f $0))"

cd "${THIS_DIR}"

chmod 700 updatePoloIp.sh
mv updatePoloIp.sh ~/anacron/hourly/
