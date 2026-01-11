# PC Systemd Services

Software running as a systemd service on a PC.

See the `README.md` in each service's directory for more information about that
service.

## Install a service

Run the `install` command and specify one or more of the available directories. A
directory may have the trailing slash (`/`).

```bash
./syapma install openwebui/ mcp-readonly-filesystem
```

## Uninstall a service

Run the `uninstall` command and specify one or more of the available directories. A
directory may have the trailing slash (`/`).

```bash
./syapma uninstall openwebui mcp-readonly-filesystem/
```

## Port assignments

| Port  | Service                  |
| ===== | ======================== |
| 8080  | OpenWebUI                |
| 8081  | MCP Read-only Filesystem |
| 8123  | Home Assistant           |
| 11434 | Ollama                   |
