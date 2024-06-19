#!/bin/bash

# Настройки
BACKUP_DIR="/root/backups"
TEMP_BACKUP_FILE="${BACKUP_DIR}/temp_backup.dump"
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +'%Y%m%d%H%M%S').dump"
POSTGRES_USER="postgres"
POSTGRES_DB="repair_shop"

# Функция для добавления задания в cron
add_cron_job() {
    # Проверка наличия задания в cron
    if ! crontab -l | grep -q "/root/backup_script.sh"; then
        # Добавление задания в cron
        (crontab -l ; echo "0 2 * * * /root/backup_script.sh") | crontab -
        echo "Cron job added to run daily at 2 AM."
    else
        echo "Cron job already exists."
    fi
}

# Добавление задания в cron
add_cron_job

# Создание временной резервной копии в формате dump
pg_dump -U $POSTGRES_USER -d $POSTGRES_DB -Fc -f $TEMP_BACKUP_FILE

# Проверка на идентичность последнего дампа
if [ -f "${BACKUP_DIR}/latest_backup.dump" ]; then
    if cmp -s "${TEMP_BACKUP_FILE}" "${BACKUP_DIR}/latest_backup.dump"; then
        echo "Backup identical to the latest one. No new backup created."
        rm -f $TEMP_BACKUP_FILE
    else
        mv $TEMP_BACKUP_FILE $BACKUP_FILE
        cp $BACKUP_FILE "${BACKUP_DIR}/latest_backup.dump"
        echo "New backup created: $BACKUP_FILE"
    fi
else
    mv $TEMP_BACKUP_FILE $BACKUP_FILE
    cp $BACKUP_FILE "${BACKUP_DIR}/latest_backup.dump"
    echo "New backup created: $BACKUP_FILE"
fi

# Удаление старых резервных копий (старше 2 недель)
find $BACKUP_DIR -type f -name "*.dump" -mtime +14 -exec rm -f {} \;

if [ $? -eq 0 ]; then
  echo "Old backups successfully deleted."
else
  echo "Failed to delete old backups."
fi