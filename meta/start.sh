#!/usr/bin/env bash
set -euo pipefail

./meta/devenv/compose.sh up --build --wait --remove-orphans --detach
echo ""
echo "Go to http://127.0.0.1:8000/cargaPerseverance.php"
