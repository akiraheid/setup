These are the components for my home server.

Read the README.md in each directory for more information about that specific
component or feature.

# Usage

Copy this directory to the server and execute the components of interest.

```bash
$ rsync -rc * home:/home/zzz/setup/
$ ssh home
# ./setup/[component]/install.sh
```

The install scripts will likely require `sudo`, which doesn't work over SSH
commands, so you must be on the server to execute the install scripts.
