# Usage

Prerequisites:

1. Create a symlink at `/mnt/k8s` pointing to some backing store for all the k8s data.

To install k3s as the first node in a cluster

    ./install_k3s.sh server --token xxx --cluster-init

To install k3s as an agent joining an existing cluster

    ./install_k3s.sh agent --token xxx --server https://example.com:6443
