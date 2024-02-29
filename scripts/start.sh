#!/usr/bin/env bash
set -euo pipefail

docker compose up -d --build --remove-orphans
echo ""
echo "Go to http://127.0.0.1:8000/cargaPerseverance.php"
