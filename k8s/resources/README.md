# K8s resources

These are resources to install on the K8s cluster.

Some of these resources are hand-made and some are generated from Helm charts.

## Generate from a Helm chart

Generating a resource file and storing it here instead of installing the Helm
chart allows for:

1. Personal review of the resources being deployed.
2. Stability in case the chart author revokes or modifies a released version.

To generate a resource YAML file from a Helm chart, use `helm template`.

    helm template --namespace a-namespace --version=1.2.3 author/chart > resource.yaml

Although `--namespace` is an argument, it does not actually generate a Namespace
on the cluster when the resources are deployed. Create a `namespace.yaml` and
add both files to the `kustomize.yaml`.

## Organizing resources

Resources are organized in directories specifying the resource name and version.
The version is either the application version (if no Helm chart exists) or the
Helm chart version (without the leading `v`).

A resource directory should look like the following:

```text
application-version/
|_kustomize.yaml
|_namespace.yaml
|_resources.yaml
```
