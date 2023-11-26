#!/usr/bin/env bash
set -euo pipefail

export DATABASE_URL="mysql://${METEO_DB_USERNAME}:${METEO_DB_PASSWORD}@${METEO_DB_HOST}:3306/${METEO_DB_NAME}"
export DBMATE_MIGRATIONS_DIR="./migrations"

dbmate --wait migrate
echo "Migration finished"
