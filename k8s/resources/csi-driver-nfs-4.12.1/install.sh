#!/usr/bin/env bash
# Install CSI Driver NFS

set -e

THIS_DIR=$(dirname "$(readlink -f "$0")")
kubectl apply -k "${THIS_DIR}"

bash "${THIS_DIR}/test.sh"
