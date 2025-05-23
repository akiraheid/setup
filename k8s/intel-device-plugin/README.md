The contents of this directory are from `/deployments/` from the Intel Device Plugins for Kubernetes [repo](https://github.com/intel/intel-device-plugins-for-kubernetes).

# Usage

To install, run the following:

```bash
# Create NodeFeatureRules for detecting GPUs on nodes
$ kubectl apply -k ./nfd/overlays/node-feature-rules

# Create GPU plugin daemonset
$ kubectl apply -k ./gpu_plugin/overlays/nfd_labeled_nodes
```

Check that the NFD labels have been created

```bash
$ kubectl get no -o json | jq ".items[].metadata.labels"
{
  "kubernetes.io/arch": "amd64",
  "kubernetes.io/os": "linux",
  "feature.node.kubernetes.io/cpu-cpuid.ADX": "true",
  "feature.node.kubernetes.io/cpu-cpuid.AESNI": "true",
  "feature.node.kubernetes.io/cpu-cpuid.AVX": "true",
...
```
