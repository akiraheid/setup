#!/usr/bin/env bash
# Test Ollama was deployed successfully.

set -e

kubectl rollout status --watch --timeout=30s -n ollama deployment/ollama
