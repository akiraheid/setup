# Usage

## Prerequisites

1. Create a symlink at `/mnt/k8s` pointing to some backing store for all the K8s data.

## Install K3s

To install K3s as the first node in a cluster

    ./install_k3s.sh server --token xxx --cluster-init

To install K3s as an agent joining an existing cluster

    ./install_k3s.sh agent --token xxx --server https://example.com:6443

## Install K8s resources

Install all the K8s resources.

    ./configure_cluster.sh

This will ensure that resources are installed in the right order and verified before installing the next one.
