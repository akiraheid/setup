#!/usr/bin/env bash
set -e

thisDir=$(dirname "$(readlink -f "$0")")
kubectl apply -k "${thisDir}/deployments/nfd/overlays/node-feature-rules"

bash "${thisDir}/../cert-manager-1.18.0/install.sh"
kubectl apply -k "${thisDir}/deployments/operator/default"
