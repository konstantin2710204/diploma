DROP DATABASE IF EXISTS repair_shop;

CREATE DATABASE repair_shop;

\c repair_shop;

-- Удаление существующих таблиц
DROP TABLE IF EXISTS archived_orders CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS devices CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS passwords CASCADE;

-- Удаление ролей, если они существуют
DROP ROLE IF EXISTS receptionist;
DROP ROLE IF EXISTS engineer;
DROP ROLE IF EXISTS service_owner;
DROP ROLE IF EXISTS db_admin;

DROP SCHEMA IF EXISTS repair_shop;

CREATE SCHEMA repair_shop;

SET search_path = 'repair_shop';

-- Установка расширения для шифрования и хеширования
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Создание таблицы паролей
CREATE TABLE passwords (
    password_id SERIAL PRIMARY KEY,
    hashed_password TEXT NOT NULL  -- Храним хешированный пароль
);

-- Создание таблицы сотрудников
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    login VARCHAR(255) UNIQUE NOT NULL,
    password_id INT REFERENCES passwords(password_id)
);

-- Создание таблицы клиентов
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    name BYTEA NOT NULL,  -- Шифрованные данные
    contact_info BYTEA NOT NULL  -- Шифрованные данные
);

-- Создание таблицы устройств
CREATE TABLE devices (
    device_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    model VARCHAR(255) NOT NULL,
    serial_number VARCHAR(255) NOT NULL
);

-- Создание таблицы заказов
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    device_id INT REFERENCES devices(device_id),
    status VARCHAR(50) NOT NULL DEFAULT 'создан',
    engineer_id INT REFERENCES employees(employee_id),
    creation_date DATE NOT NULL,
    completion_date DATE
);

-- Создание таблицы архивных заказов
CREATE TABLE archived_orders (
    order_id INT PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    device_id INT REFERENCES devices(device_id),
    status VARCHAR(50) NOT NULL,
    engineer_id INT REFERENCES employees(employee_id),
    creation_date DATE NOT NULL,
    completion_date DATE NOT NULL
);

-- Создание ролей базы данных
CREATE ROLE receptionist;
CREATE ROLE engineer;
CREATE ROLE service_owner;
CREATE ROLE db_admin;

-- Назначение прав доступа ролям
GRANT SELECT, INSERT, UPDATE ON orders, clients TO receptionist;
GRANT SELECT, UPDATE ON orders TO engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO service_owner;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO db_admin;

-- Создание пользователей для каждой роли
CREATE USER receptionist_user WITH LOGIN PASSWORD 'password_receptionist';
CREATE USER engineer_user WITH LOGIN PASSWORD 'password_engineer';
CREATE USER service_owner_user WITH LOGIN PASSWORD 'password_service_owner';
CREATE USER db_admin_user WITH LOGIN PASSWORD 'password_db_admin';

-- Вставка хешированных паролей
INSERT INTO passwords (hashed_password)
SELECT crypt('password' || i, gen_salt('bf'))
FROM generate_series(1, 30) s(i);

-- Вставка сотрудников
INSERT INTO employees (name, role, login, password_id)
SELECT
    'Employee ' || i,
    CASE
        WHEN i <= 5 THEN 'receptionist'
        WHEN i <= 10 THEN 'engineer'
        WHEN i = 11 THEN 'service_owner'
        ELSE 'db_admin'
    END,
    'login' || i,
    i
FROM generate_series(1, 30) s(i);

-- Вставка клиентов
INSERT INTO clients (name, contact_info)
SELECT
    pgp_sym_encrypt('Client ' || i, 'секретный_ключ'),
    pgp_sym_encrypt('client' || i || '@example.com', 'секретный_ключ')
FROM generate_series(1, 100) s(i);

-- Вставка устройств
INSERT INTO devices (type, model, serial_number)
SELECT
    'Type ' || i,
    'Model ' || i,
    'SN' || i
FROM generate_series(1, 100) s(i);

-- Вставка заказов
INSERT INTO orders (client_id, device_id, status, engineer_id, creation_date)
SELECT
    (RANDOM() * 99 + 1)::INT,
    (RANDOM() * 99 + 1)::INT,
    CASE
        WHEN RANDOM() < 0.5 THEN 'в процессе'
        ELSE 'создан'
    END,
    (RANDOM() * 5 + 6)::INT,  -- Инженеры имеют ID от 6 до 10
    CURRENT_DATE - (RANDOM() * 30)::INT
FROM generate_series(1, 200) s(i);
