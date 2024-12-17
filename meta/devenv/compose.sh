#!/usr/bin/env bash
set -euo pipefail

exec docker compose \
  --project-name weather-station \
  --project-directory . \
  --file meta/devenv/_/docker-compose.yml \
  "$@"
