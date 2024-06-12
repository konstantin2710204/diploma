# Используем базовый образ PostgreSQL 16.2 на основе Alpine Linux
FROM postgres:alpine

# Устанавливаем необходимые переменные окружения
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB postgres

COPY create_dump.sh /usr/local/bin/create_dump.sh
RUN chmod +x /usr/local/bin/create_dump.sh
RUN apk add --no-cache tzdata rsync openssh && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && echo "Europe/Moscow" > /etc/timezone

# Копирование SQL-скрипта для инициализации базы данных
COPY init.sql /docker-entrypoint-initdb.d/
