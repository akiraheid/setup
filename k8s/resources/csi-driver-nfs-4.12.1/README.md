# CSI Driver NFS

Repository link: https://github.com/kubernetes-csi/csi-driver-nfs

## Installation

Run the install script.

```bash
bash ./install.sh
```

## Upgrade

Copy the new version's resources from the [csi-driver-nfs repository](https://github.com/kubernetes-csi/csi-driver-nfs/tree/master/deploy).

Be sure to only copy the files required by the [install-driver.sh](https://github.com/kubernetes-csi/csi-driver-nfs/blob/master/deploy/install-driver.sh) for that version.

Deploy the new settings.

```bash
kubectl apply -k
```

Run the test.

```bash
bash ./test.sh
```

If the test fails, rollback.

```bash
git checkout -- *.yaml
kubectl apply -k .
```

Otherwise, commit the changes.

```bash
git commit -a
```
