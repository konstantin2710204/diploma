# Используем базовый образ PostgreSQL 16.2 на основе Alpine Linux
FROM postgres:16.2-alpine

# Устанавливаем необходимые переменные окружения
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_DB=repair_shop

# Копирование скриптов для резервного копирования и восстановления
COPY backup_script.sh /root/backup_script.sh
COPY restore_script.sh /root/restore_script.sh

# Установка прав на выполнение скриптов
RUN chmod +x /root/backup_script.sh /root/restore_script.sh

# Создание директории для резервных копий
RUN mkdir -p /root/backups

# Запуск crond и PostgreSQL
CMD crond && docker-entrypoint.sh postgres

# Копирование SQL-скрипта для инициализации базы данных
COPY init.sql /docker-entrypoint-initdb.d/
