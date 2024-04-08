#!/bin/bash

# Устанавливаем переменные окружения
PGUSER="postgres"
PGHOST="localhost"
PGDATABASE="repair"
BACKUP_FILE="/var/lib/postgresql/data/backup.sql"

# Создаем резервную копию базы данных
pg_dump -U "$PGUSER" -h "$PGHOST" -F p "$PGDATABASE" > "$BACKUP_FILE"

# Восстанавливаем базу данных на текущем контейнере
psql -U "$PGUSER" -d "$PGDATABASE" -f "$BACKUP_FILE"

sleep 3600