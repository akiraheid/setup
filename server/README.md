The home server setup and configuration files.

# Adding a new directory to `/raid`

```bash
mkdir /raid/newdir
chmod 770 /raid/newdir
groupadd groupname
chgrp groupname newdir
```

To allow users to write to that directory, add them to that group.

```bash
usermod -a -G groupname username
```

# Jellyfin

Jellyfin gets read-only permission from several directories in `/raid`.

There is no guest account because all libraries are private.
