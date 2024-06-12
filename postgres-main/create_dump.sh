#!/bin/sh
set -e

# Настройки
BACKUP_DIR="/backups"
DB_NAME="repair_shop"
DB_USER="postgres"
DB_PASSWORD="password"

# Дата и время для имени файла
DATE=$(date +%Y%m%d_%H%M%S)

# Создание дампа
mkdir -p $BACKUP_DIR
PGPASSWORD=$DB_PASSWORD pg_dump -U $DB_USER -F c $DB_NAME > $BACKUP_DIR/$DB_NAME_$DATE.dump

# Передача дампа на резервный сервер
rsync -avz -e "ssh -o StrictHostKeyChecking=no" $BACKUP_DIR/$DB_NAME_$DATE.dump root@172.17.0.3:/backups/
