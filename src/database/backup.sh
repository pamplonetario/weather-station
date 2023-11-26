#!/usr/bin/env bash
set -euo pipefail

backup_name="${MYSQL_DATABASE}_$(date --utc +'%Y%m%d%H%M%S')"
echo "Starting backup: ${backup_name}"
mkdir -p /backups
mysqldump \
  --user=root \
  --password="${MYSQL_ROOT_PASSWORD}" \
  --no-create-db \
  --no-create-info \
  "${MYSQL_DATABASE}" |
  gzip >"/backups/${backup_name}.gz"
