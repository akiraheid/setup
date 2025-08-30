#!/bin/bash
set -e

THIS_DIR=$(dirname "$(readlink -f "$0")")

kubectl delete -f "${THIS_DIR}/csi-nfs-controller.yaml" --ignore-not-found
kubectl delete -f "${THIS_DIR}/csi-nfs-node.yaml" --ignore-not-found
kubectl delete -f "${THIS_DIR}/csi-nfs-driverinfo.yaml" --ignore-not-found
kubectl delete -f "${THIS_DIR}/rbac-csi-nfs.yaml" --ignore-not-found
