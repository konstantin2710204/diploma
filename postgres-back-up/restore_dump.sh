#!/bin/sh
set -e

# Настройки
BACKUP_DIR="/backups"
DB_NAME="repair_shop"
DB_USER="postgres"
DB_PASSWORD="password"
LATEST_DUMP=$(ls -t $BACKUP_DIR/*.dump | head -1)

# Восстановление из дампа
if [ -f "$LATEST_DUMP" ]; then
  PGPASSWORD=$DB_PASSWORD pg_restore -U $DB_USER -d $DB_NAME -c $LATEST_DUMP
fi

# Удаление дампов старше двух недель
find $BACKUP_DIR -type f -name '*.dump' -mtime +14 -exec rm {} \;
