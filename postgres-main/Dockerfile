# Используем базовый образ PostgreSQL 16.2 на основе Alpine Linux
FROM postgres:16.2-alpine

# Устанавливаем необходимые переменные окружения
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB postgres

# Этот файл Dockerfile не требует дополнительной настройки
# PostgreSQL будет запущен с указанными переменными окружения

# Копирование SQL-скрипта для инициализации базы данных
COPY init.sql /docker-entrypoint-initdb.d/
