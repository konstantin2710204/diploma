
# Система для сервисного центра по ремонту электроники

Этот проект представляет собой систему для сервисного центра по ремонту электроники. Система развернута в Docker-контейнерах и включает следующие компоненты:

- **PostgreSQL база данных**: Контейнер расположен в папке `postgres-main` и называется `db-main`.
- **Front-end сайта клиентов**: Контейнер расположен в папке `front-end-user` и называется `front-end-user`. Реализован на Next.js.
- **Back-end сайта клиентов**: Контейнер расположен в папке `back-end-user` и называется `back-end-user`. Реализован на FastAPI.
- **Сайт сотрудников**: Контейнер расположен в папке `service-response` и называется `service-response`. Реализован на Flask.
- **Система мониторинга**: Используется Zabbix, который развертывается на трех контейнерах `zabbix-postgres`, `zabbix-web`, `zabbix-server`, а также локально на системе разворачивается Zabbix Agent.

## Запуск контейнеров

### PostgreSQL

```sh
docker build -t db-main .
docker run -p 5432:5432 --name db-main db-main
```

### Back-end

```sh
docker build -t back-end-user .
docker run -p 8000:8000 --name back-end-user back-end-user
```

### Front-end

```sh
docker build -t front-end-user .
docker run -p 3000:3000 --name front-end-user front-end-user
```

### Сайт сотрудников

```sh
docker build -t service-response .
docker run -p 5000:5000 --name service-response service-response
```

## Настройка Zabbix

### 1. Создаем ресурсы для проброса в контейнеры

```sh
mkdir /var/lib/zabbix/
cd /var/lib/zabbix/
ln -s /usr/share/zoneinfo/Asia/Tashkent localtime
echo 'Asia/Tashkent' > timezone
```

### 2. Создаем Docker сеть

```sh
sudo docker network create zabbix-net
```

### 3. Запуск контейнера с Postgresql

```sh
sudo docker run -d \
--name zabbix-postgres \
--network zabbix-net \
-v /var/lib/zabbix/timezone:/etc/timezone \
-v /var/lib/zabbix/localtime:/etc/localtime \
-e POSTGRES_PASSWORD=zabbix \
-e POSTGRES_USER=zabbix postgres:alpine
```

### 4. Запуск контейнера с Zabbix-server

```sh
sudo docker run \
--name zabbix-server \
--network zabbix-net \
-v /var/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts \
-v /var/lib/zabbix/timezone:/etc/timezone \
-v /var/lib/zabbix/localtime:/etc/localtime \
-p 10051:10051 -e DB_SERVER_HOST="zabbix-postgres" \
-e POSTGRES_USER="zabbix" \
-e POSTGRES_PASSWORD="zabbix" \
-d zabbix/zabbix-server-pgsql:alpine-latest
```

### 5. Запуск контейнера с Zabbix Web-server

```sh
sudo docker run \
--name zabbix-web \
-p 80:8080 -p 443:8443 \
--network zabbix-net \
-e DB_SERVER_HOST="zabbix-postgres" \
-v /var/lib/zabbix/timezone:/etc/timezone \
-v /var/lib/zabbix/localtime:/etc/localtime \
-e POSTGRES_USER="zabbix" \
-e POSTGRES_PASSWORD="zabbix" \
-e ZBX_SERVER_HOST="zabbix-server" \
-e PHP_TZ="Europe/Moscow" \
-d zabbix/zabbix-web-nginx-pgsql:alpine-latest
```

### 6. Установка Zabbix-agent 2

```sh
apt-get install zabbix-agent2
```

---

# System for Electronics Repair Service Center

This project is a system for an electronics repair service center. The system is deployed in Docker containers and includes the following components:

- **PostgreSQL Database**: Container is located in the `postgres-main` folder and named `db-main`.
- **Client Site Front-end**: Container is located in the `front-end-user` folder and named `front-end-user`. Implemented in Next.js.
- **Client Site Back-end**: Container is located in the `back-end-user` folder and named `back-end-user`. Implemented in FastAPI.
- **Employee Site**: Container is located in the `service-response` folder and named `service-response`. Implemented in Flask.
- **Monitoring System**: Zabbix is used, deployed on three containers `zabbix-postgres`, `zabbix-web`, `zabbix-server`, and locally on the system as Zabbix Agent.

## Running the Containers

### PostgreSQL

```sh
docker build -t db-main .
docker run -p 5432:5432 --name db-main db-main
```

### Back-end

```sh
docker build -t back-end-user .
docker run -p 8000:8000 --name back-end-user back-end-user
```

### Front-end

```sh
docker build -t front-end-user .
docker run -p 3000:3000 --name front-end-user front-end-user
```

### Employee Site

```sh
docker build -t service-response .
docker run -p 5000:5000 --name service-response service-response
```

## Setting Up Zabbix

### 1. Create resources for container binding

```sh
mkdir /var/lib/zabbix/
cd /var/lib/zabbix/
ln -s /usr/share/zoneinfo/Asia/Tashkent localtime
echo 'Asia/Tashkent' > timezone
```

### 2. Create Docker network

```sh
sudo docker network create zabbix-net
```

### 3. Run PostgreSQL container

```sh
sudo docker run -d \
--name zabbix-postgres \
--network zabbix-net \
-v /var/lib/zabbix/timezone:/etc/timezone \
-v /var/lib/zabbix/localtime:/etc/localtime \
-e POSTGRES_PASSWORD=zabbix \
-e POSTGRES_USER=zabbix postgres:alpine
```

### 4. Run Zabbix-server container

```sh
sudo docker run \
--name zabbix-server \
--network zabbix-net \
-v /var/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts \
-v /var/lib/zabbix/timezone:/etc/timezone \
-v /var/lib/zabbix/localtime:/etc/localtime \
-p 10051:10051 -e DB_SERVER_HOST="zabbix-postgres" \
-e POSTGRES_USER="zabbix" \
-e POSTGRES_PASSWORD="zabbix" \
-d zabbix/zabbix-server-pgsql:alpine-latest
```

### 5. Run Zabbix Web-server container

```sh
sudo docker run \
--name zabbix-web \
-p 80:8080 -p 443:8443 \
--network zabbix-net \
-e DB_SERVER_HOST="zabbix-postgres" \
-v /var/lib/zabbix/timezone:/etc/timezone \
-v /var/lib/zabbix/localtime:/etc/localtime \
-e POSTGRES_USER="zabbix" \
-e POSTGRES_PASSWORD="zabbix" \
-e ZBX_SERVER_HOST="zabbix-server" \
-e PHP_TZ="Europe/Moscow" \
-d zabbix/zabbix-web-nginx-pgsql:alpine-latest
```

### 6. Install Zabbix-agent 2

```sh
apt-get install zabbix-agent2
```
