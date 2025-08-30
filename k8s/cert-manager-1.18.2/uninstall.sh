#!/usr/bin/env bash
set -e

thisDir=$(dirname "$(readlink -f "$0")")

# Delete unwanted cert-manager resources
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces

kubectl delete -f "${thisDir}/cert-manager-1.18.2.yaml"

# Delete orphaned leases
kubectl delete lease -n kube-system cert-manager-cainjector-leader-election cert-manager-controller
