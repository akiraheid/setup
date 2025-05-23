The contents of this directory are from the `/deployment/` from the Node Feature Discovery (NFD) [repo](https://github.com/kubernetes-sigs/node-feature-discovery).

# Usage

To install, run the following:

```bash
kubectl apply -k ./overlays/default
```

Wait until the NFD master and NFD worker are running.

```bash
$ kubectl -n node-feature-discovery get ds,deploy
NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/nfd-worker    2         2         2       2            2           <none>          10s

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nfd-master   1/1     1            1           17s
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
