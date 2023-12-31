#!/usr/bin/env bash
set -euo pipefail

backup_name="${MYSQL_DATABASE}_$(date --utc +'%Y%m%d%H%M%S')"
echo "Starting backup: ${backup_name}"
mkdir -p /backup
mysqldump \
  --user=root \
  --password="${MYSQL_ROOT_PASSWORD}" \
  --single-transaction=TRUE \
  --quick \
  --no-create-db \
  --no-create-info \
  "${MYSQL_DATABASE}" |
  gzip >"/backup/${backup_name}.gz"

# About --single-transaction
# https://dev.mysql.com/doc/refman/5.7/en/mysqldump.html#option_mysqldump_single-transaction
