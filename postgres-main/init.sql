DROP DATABASE IF EXISTS repair_shop;

CREATE DATABASE repair_shop;

\c repair_shop;

-- Удаление существующих таблиц и ролей
DROP SCHEMA IF EXISTS repair_shop CASCADE;
CREATE SCHEMA repair_shop;
SET search_path = 'repair_shop';

-- Установка расширения для шифрования и хеширования
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Создание таблицы паролей
CREATE TABLE passwords (
    password_id SERIAL PRIMARY KEY,
    hashed_password TEXT NOT NULL
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
    name BYTEA NOT NULL,
    contact_info BYTEA NOT NULL
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

-- Создание архивной таблицы заказов
CREATE TABLE archived_orders (
    order_id INT PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    device_id INT REFERENCES devices(device_id),
    status VARCHAR(50) NOT NULL,
    engineer_id INT REFERENCES employees(employee_id),
    creation_date DATE NOT NULL,
    completion_date DATE NOT NULL
);

-- Создание таблицы сборок компьютеров
CREATE TABLE computer_builds (
    build_id SERIAL PRIMARY KEY,
    engineer_id INT REFERENCES employees(employee_id),
    client_id INT REFERENCES clients(client_id),
    components TEXT NOT NULL,
    components_cost DECIMAL(10, 2) NOT NULL,
    service_fee DECIMAL(10, 2) GENERATED ALWAYS AS (components_cost * 0.08) STORED,
    status VARCHAR(50) NOT NULL DEFAULT 'создан'
);

-- Создание архивной таблицы для сборок компьютеров
CREATE TABLE archived_computer_builds (
    build_id INT PRIMARY KEY,
    engineer_id INT REFERENCES employees(employee_id),
    client_id INT REFERENCES clients(client_id),
    components TEXT NOT NULL,
    components_cost DECIMAL(10, 2) NOT NULL,
    service_fee DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    completion_date DATE NOT NULL
);

-- Создание функции и триггера для архивирования заказов
CREATE OR REPLACE FUNCTION archive_order()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'завершен' THEN
        INSERT INTO archived_orders (order_id, client_id, device_id, status, engineer_id, creation_date, completion_date)
        VALUES (NEW.order_id, NEW.client_id, NEW.device_id, NEW.status, NEW.engineer_id, NEW.creation_date, CURRENT_DATE);
        
        DELETE FROM orders WHERE order_id = NEW.order_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_archive_order
AFTER UPDATE ON orders
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'завершен')
EXECUTE FUNCTION archive_order();

-- Создание функции и триггера для архивирования сборок компьютеров
CREATE OR REPLACE FUNCTION archive_computer_build()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'завершен' THEN
        INSERT INTO archived_computer_builds (build_id, engineer_id, components, components_cost, service_fee, status, completion_date)
        VALUES (NEW.build_id, NEW.engineer_id, NEW.components, NEW.components_cost, NEW.service_fee, NEW.status, CURRENT_DATE);
        
        DELETE FROM computer_builds WHERE build_id = NEW.build_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_archive_computer_build
AFTER UPDATE ON computer_builds
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'завершен')
EXECUTE FUNCTION archive_computer_build();

-- Создание ролей базы данных
CREATE ROLE receptionist;
CREATE ROLE engineer;
CREATE ROLE service_owner;
CREATE ROLE db_admin;

-- Создание пользователей для каждой роли
CREATE USER receptionist_user WITH LOGIN PASSWORD 'password_receptionist';
CREATE USER engineer_user WITH LOGIN PASSWORD 'password_engineer';
CREATE USER service_owner_user WITH LOGIN PASSWORD 'password_service_owner';
CREATE USER db_admin_user WITH LOGIN PASSWORD 'password_db_admin';

-- Назначение прав доступа ролям
GRANT SELECT, INSERT, UPDATE ON orders, clients TO receptionist;
GRANT SELECT, UPDATE ON orders TO engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA repair_shop TO service_owner;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA repair_shop TO db_admin;

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

-- Вставка данных в таблицу сборок компьютеров
INSERT INTO computer_builds (engineer_id, components, components_cost, status)
VALUES 
    (6, '["GPU: GeForce RTX 3060", "CPU: AMD Ryzen 5 5600X", "RAM: 16GB DDR4", "Motherboard: MSI B550-A PRO"]', 1200.00, 'в процессе'),
    (7, '["GPU: GeForce RTX 3070", "CPU: Intel i7-10700K", "RAM: 32GB DDR4", "Motherboard: ASUS ROG Strix Z490-E"]', 1800.00, 'создан'),
    (8, '["GPU: Radeon RX 6800", "CPU: AMD Ryzen 7 5800X", "RAM: 32GB DDR4", "Motherboard: Gigabyte X570 Aorus Elite"]', 1600.00, 'в процессе'),
    (9, '["GPU: GeForce RTX 3080", "CPU: Intel i9-10900K", "RAM: 64GB DDR4", "Motherboard: ASUS ROG Maximus XII Extreme"]', 3200.00, 'завершен');
