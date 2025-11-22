#!/usr/bin/env bash
# Test OpenWebUI was deployed successfully.

set -e

kubectl rollout status --watch --timeout=30s -n openwebui deployment/openwebui
