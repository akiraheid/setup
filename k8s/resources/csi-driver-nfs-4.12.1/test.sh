#!/usr/bin/env bash
# Test the CSI Driver NFS is working.

set -e

THIS_DIR=$(dirname "$(readlink -f "$0")")

kubectl rollout status --watch --timeout=10s -n kube-system deployment/csi-nfs-controller
kubectl get pod -n kube-system -l app=csi-nfs-node | grep -v 'Running'

kubectl apply -f "${THIS_DIR}/test.yaml"

set +e
kubectl rollout status --watch --timeout=10s deployment/nfs-test
ret=$?
set -e

kubectl delete -f test.yaml

exit "$ret"
