#!/bin/bash
# Script to configure a new server
set -e

pushd ../common
bash setupAll.sh
popd

bash nginx/setup.sh
bash polo/setup.sh

bash ../common/setupDummyUser.sh
bash jellyfin/setup.sh
