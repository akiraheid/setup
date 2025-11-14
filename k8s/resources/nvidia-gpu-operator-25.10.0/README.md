The `resources.yaml` was generated from the following command.

```bash
helm template \
    --include-crds \
    --namespace nvidia-gpu-operator \
    --version=v25.10.0 \
    --set driver.enable=false \
    --set nfd.enabled=false \
    nvidia/gpu-operator > resources.yaml
```

- `--set driver.enable=false` is set because the GPU drivers are installed on each node. This prevents all nodes from having to be the same kernel.
- `--set nfd.enabled=false` is set because NFD is already installed.
