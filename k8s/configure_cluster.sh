#!/bin/bash
# Configure the K8s cluster to the operational state.
#
# Usage:
#   configure_cluster.sh

set -e

info() {
    echo '[INFO] ' "$@"
}

THIS_DIR=$(dirname "$(readlink -f "$0")")

install_nfd() {
	kubectl apply -k "${THIS_DIR}/resources/node-feature-discovery-0.16.4/deployment/overlays/default"

	sleep 1s

	info "Verifying all pods are in the 'Running' state"
	(kubectl get pods \
			-n node-feature-discovery \
			--no-headers \
			-o custom-columns=:.status.phase \
		| grep -v Running) || true
}

install_nvidiagpuoperator() {
	resourceDir=${THIS_DIR}/resources/nvidia-gpu-operator-25.10.0
	kubectl apply -k "${resourceDir}"

	kubectl apply -f "${resourceDir}/test.yaml"
	sleep 5s
	kubectl logs pod/cuda-vectoradd | grep PASSED
	kubectl delete -f "${resourceDir}/test.yaml"
}

{
	install_nfd
	install_nvidiagpuoperator
}
