#!/bin/bash
set -e

THIS_DIR=$(dirname "$(readlink -f "$0")")

kubectl apply -f "${THIS_DIR}/rbac-csi-nfs.yaml"
kubectl apply -f "${THIS_DIR}/csi-nfs-driverinfo.yaml"
kubectl apply -f "${THIS_DIR}/csi-nfs-controller.yaml"
kubectl apply -f "${THIS_DIR}/csi-nfs-node.yaml"

kubectl -n kube-system get pod -o wide -l app=csi-nfs-controller
kubectl -n kube-system get pod -o wide -l app=csi-nfs-node
