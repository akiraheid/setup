#!/usr/bin/env bash
set -e

thisDir=$(dirname "$(readlink -f "$0")")

kubectl apply -f "${thisDir}/cert-manager-1.18.2.yaml"

# Test that things are working. If all commands have no errors, then the test is
# successful.
kubectl apply -f "${thisDir}/test-resources.yaml"

# Give some time for the cert to be created
sleep 5s

kubectl describe certificate -n cert-manager-test
kubectl delete -f "${thisDir}/test-resources.yaml"
