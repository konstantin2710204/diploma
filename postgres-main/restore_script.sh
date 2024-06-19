#!/bin/bash

# Настройки
BACKUP_FILE="/root/backups/backup_to_restore.dump"
POSTGRES_USER="postgres"
POSTGRES_DB="repair_shop"

# Восстановление данных из dump файла
pg_restore -U $POSTGRES_USER -d $POSTGRES_DB -c < $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Restore successfully completed."
else
  echo "Restore failed."
fi
