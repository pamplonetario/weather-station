#!/usr/bin/env bash
set -euo pipefail
(cd /weather-station/schema && ./migrate.sh)
exec apache2-foreground
