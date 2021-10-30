#!/bin/bash
# Script to configure a new server
set -e

pushd ../common
bash setupAll.sh
popd

bash setupNginx.sh
bash setupServices.sh
