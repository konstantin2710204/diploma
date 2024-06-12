# Используем базовый образ PostgreSQL
FROM postgres:alpine

# Устанавливаем необходимые переменные окружения
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB postgres

# Копирование скрипта восстановления
COPY restore_dump.sh /usr/local/bin/restore_dump.sh
RUN chmod +x /usr/local/bin/restore_dump.sh

# Установка необходимых пакетов
RUN apk add --no-cache rsync tzdata openssh \
    && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
    && echo "Europe/Moscow" > /etc/timezone

# Настройка SSH
RUN ssh-keygen -A \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config

# Открытие порта SSH
EXPOSE 22

# Команда запускает и PostgreSQL и SSH серверы
CMD ["/bin/sh", "-c", "/usr/sbin/sshd && exec postgres -p 5433"]
