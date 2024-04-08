# Используем базовый образ PostgreSQL 16.2 на основе Alpine Linux
FROM postgres:16.2-alpine

# Устанавливаем необходимые переменные окружения
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB service

# Копируем скрипт для создания резервной копии и восстановления
COPY . /usr/local/bin/backup_and_restore.sh

# Устанавливаем утилиты для работы со скриптом
RUN apk add --no-cache bash

# Запускаем скрипт резервного копирования и восстановления при запуске контейнера
# CMD ["bash", "/usr/local/bin/backup_and_restore.sh"]
