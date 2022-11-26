The home server setup and configuration files.

# Adding a new directory to `/raid`

`771` permissions are required for directories that are mounted to a container.

All directories that will be read-write will have to be owned by the user starting the container. Otherwise, the uid/gid of the folder won't correspond to a uid/gid in the container and end up being owned by `nobody/nogroup`.

For example, if `/raid/dir` is owned by `root/shared`, then a container run by `user` that is part of the `shared` group would be able to access it on the host, but the container can't map the uid/gid.

```bash
mkdir /raid/newdir
chmod 771 /raid/newdir
groupadd groupname
chgrp groupname newdir
```

To allow users to write to that directory, add them to that group.

```bash
usermod -a -G groupname username
```

# Services

## Jellyfin

Jellyfin gets read-only permission from several directories in `/raid`.

There is no guest account because all libraries are private.

## Nextcloud

Has volumes for configuration, but data lives on `/raid/nextcloud/`
