#!/usr/bin/env bash
# Install OpenWebUI

set -e

THIS_DIR=$(dirname "$(readlink -f "$0")")
kubectl apply -k "${THIS_DIR}"

bash "${THIS_DIR}/test.sh"
