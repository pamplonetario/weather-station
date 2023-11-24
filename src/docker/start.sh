#!/usr/bin/env bash
set -euo pipefail
(cd /weather-station/database && ./migrate.sh)
exec apache2-foreground
