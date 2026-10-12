# Setup

Set up machines.

## Usage

Run the `configure.sh` script found in the various machine folders.

```bash
bash ./<machine>/configure.sh
```

## Directory structure

There are dedicated directories for configuring machines and a `common` directory
for common configurations and scripts between all machines.

```
setup/
|_common/
|_laptop/
|_nas/
|_pc/
|_vps/
```

### `laptop/`

Mobile laptop, mean to operate outside the home network.

### `nas/`

Network Attached Storage (NAS) device on the home network.

### `pc/`

Stationary machine on the home network.

### `vps/`

Virtual Private Server (VPS) hosted via VPS service.
