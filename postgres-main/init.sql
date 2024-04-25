-- Удаляем базу данных и пользователей, если они существуют
DROP DATABASE IF EXISTS repair_shop;

DROP USER IF EXISTS receptionist_user;
DROP USER IF EXISTS engineer_user;
DROP USER IF EXISTS service_owner_user;
DROP USER IF EXISTS db_admin_user;

DROP ROLE IF EXISTS receptionist;
DROP ROLE IF EXISTS engineer;
DROP ROLE IF EXISTS service_owner;
DROP ROLE IF EXISTS db_admin;

-- Создаем базу данных
CREATE DATABASE repair_shop;
\c repair_shop;

-- Создаем схему и устанавливаем необходимые расширения
CREATE SCHEMA repair_shop;
SET search_path TO 'repair_shop';
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Создание таблицы с заявками на обратный звонок по ремонту
CREATE TABLE callback_orders (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NOT NULL
);

--Создание таблицы с заявками на обратный звонок по сборкам компьютеров
CREATE TABLE callback_computer_builds (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    budget DECIMAL(10, 2), -- Бюджет на сборку
    usage_tasks TEXT,       -- Задачи использования компьютера
    build_preferences TEXT  -- Предпочтения по сборке
);

-- Создаем таблицы
CREATE TABLE passwords (
    password_id SERIAL PRIMARY KEY,
    hashed_password TEXT NOT NULL
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    specialization VARCHAR(255),
    login VARCHAR(255) UNIQUE NOT NULL,
    password_id INT REFERENCES passwords(password_id)
);

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    name text NOT NULL,
    contact_info text NOT NULL
);

CREATE TABLE devices (
    device_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    model VARCHAR(255) NOT NULL,
    serial_number VARCHAR(255) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    device_id INT REFERENCES devices(device_id),
    status VARCHAR(50) NOT NULL DEFAULT 'создан' CHECK (status in ('создан', 'в работе', 'готов к выдаче', 'завершен')),
    engineer_id INT REFERENCES employees(employee_id),
    creation_date DATE NOT NULL,
    cost DECIMAL(10, 2) -- Добавляем столбец для стоимости
);

CREATE TABLE computer_builds (
    build_id SERIAL PRIMARY KEY,
    engineer_id INT REFERENCES employees(employee_id),
    client_id INT REFERENCES clients(client_id),
    components TEXT NOT NULL,
    components_cost DECIMAL(10, 2) NOT NULL,
    service_fee DECIMAL(10, 2) GENERATED ALWAYS AS (components_cost * 0.08) STORED,
    creation_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'создан' CHECK (status in ('создан', 'в работе', 'готов к выдаче', 'завершен'))
);

CREATE TABLE archived_orders (
    order_id INT PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    device_id INT REFERENCES devices(device_id),
    status VARCHAR(50) NOT NULL CHECK (status in ('завершен')),
    engineer_id INT REFERENCES employees(employee_id),
    creation_date DATE NOT NULL,
    completion_date DATE NOT NULL
);

CREATE TABLE archived_computer_builds (
    build_id INT PRIMARY KEY,
    engineer_id INT REFERENCES employees(employee_id),
    client_id INT REFERENCES clients(client_id),
    components TEXT NOT NULL,
    components_cost DECIMAL(10, 2) NOT NULL,
    service_fee DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status in ('завершен')),
    creation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    completion_date DATE NOT NULL
);

-- Создаем роли и пользователей для каждой роли
CREATE ROLE receptionist;
CREATE ROLE engineer;
CREATE ROLE service_owner;
CREATE ROLE db_admin;

-- Назначаем права доступа
GRANT SELECT, INSERT, UPDATE ON orders, clients TO receptionist;
GRANT SELECT, UPDATE ON orders TO engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA repair_shop TO service_owner;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA repair_shop TO db_admin;

-- Создаем функцию триггера для шифрования данных клиента
CREATE OR REPLACE FUNCTION encrypt_client_data()
RETURNS TRIGGER AS $$
BEGIN
  -- Шифруем имя и контактные данные клиента перед вставкой
  NEW.name := pgp_sym_encrypt(NEW.name, 'secret_key');
  NEW.contact_info := pgp_sym_encrypt(NEW.contact_info, 'secret_key');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер, который будет вызывать функцию encrypt_client_data
-- при каждой вставке записи в таблицу clients
CREATE TRIGGER trigger_encrypt_client_data
BEFORE INSERT ON repair_shop.clients
FOR EACH ROW EXECUTE FUNCTION encrypt_client_data();


-- Создаем функции и триггеры для архивирования заказов
CREATE OR REPLACE FUNCTION archive_order() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'завершен' THEN
        INSERT INTO repair_shop.archived_orders (order_id, client_id, device_id, status, engineer_id, creation_date, completion_date)
        VALUES (NEW.order_id, NEW.client_id, NEW.device_id, NEW.status, NEW.engineer_id, NEW.creation_date, CURRENT_DATE);
        DELETE FROM repair_shop.orders WHERE order_id = NEW.order_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_archive_order AFTER UPDATE ON repair_shop.orders
FOR EACH ROW WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'завершен')
EXECUTE FUNCTION archive_order();

CREATE OR REPLACE FUNCTION archive_computer_build() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'завершен' THEN
        INSERT INTO repair_shop.archived_computer_builds (build_id, engineer_id, components, components_cost, service_fee, status, completion_date)
        VALUES (NEW.build_id, NEW.engineer_id, NEW.components, NEW.components_cost, NEW.service_fee, NEW.status, CURRENT_DATE);
        DELETE FROM repair_shop.computer_builds WHERE build_id = NEW.build_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_archive_computer_build AFTER UPDATE ON repair_shop.computer_builds
FOR EACH ROW WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'завершен')
EXECUTE FUNCTION archive_computer_build();

CREATE OR REPLACE FUNCTION assign_engineer()
RETURNS TRIGGER AS $$
DECLARE
    selected_engineer_id INT;
    device_type VARCHAR;
BEGIN
    -- Получение типа устройства для нового заказа
    SELECT type INTO device_type FROM repair_shop.devices WHERE device_id = NEW.device_id;

    -- Выбор инженера с наименьшим количеством активных заказов, который специализируется на типе устройства заказа
    SELECT e.employee_id INTO selected_engineer_id
    FROM repair_shop.employees e
    LEFT JOIN repair_shop.orders o ON e.employee_id = o.engineer_id AND o.status NOT IN ('завершен', 'готов к выдаче', 'в работе')
    WHERE e.specialization = device_type
    GROUP BY e.employee_id
    ORDER BY COUNT(o.order_id) ASC
    LIMIT 1;

    -- Проверяем, найден ли инженер
    IF selected_engineer_id IS NULL THEN
        RAISE EXCEPTION 'Не найден инженер с необходимой специализацией: %', device_type;
    ELSE
        NEW.engineer_id := selected_engineer_id;  -- Назначение найденного инженера заказу
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_assign_engineer
BEFORE INSERT ON repair_shop.orders
FOR EACH ROW
EXECUTE FUNCTION assign_engineer();

CREATE OR REPLACE FUNCTION assign_assembler()
RETURNS TRIGGER AS $$
DECLARE
    selected_engineer_id INT;
BEGIN
    -- Выбор инженера с наименьшим количеством активных заказов, который специализируется на типе устройства заказа
    SELECT e.employee_id INTO selected_engineer_id
    FROM repair_shop.employees e
    LEFT JOIN repair_shop.computer_builds cb ON e.employee_id = cb.engineer_id AND cb.status NOT IN ('завершен', 'готов к выдаче', 'в работе')
    WHERE e.specialization = 'Сборщик ПК'
    GROUP BY e.employee_id
    ORDER BY COUNT(cb.build_id) ASC
    LIMIT 1;

    -- Проверяем, найден ли инженер
    IF selected_engineer_id IS NULL THEN
        RAISE EXCEPTION 'Не найден инженер с необходимой специализацией';
    ELSE
        NEW.engineer_id := selected_engineer_id;  -- Назначение найденного инженера заказу
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_assign_assembler
BEFORE INSERT ON repair_shop.computer_builds
FOR EACH ROW
EXECUTE FUNCTION assign_assembler();

-- Вставка начальных данных (вставки для таблиц passwords, employees, clients и т.д. здесь не повторяются для краткости)

INSERT INTO callback_orders (name, phone_number) VALUES
('Петр Иванов', '+79031567890'),
('Мария Семенова', '+79032567890'),
('Анатолий Жуков', '+79033567890'),
('Светлана Петрова', '+79034567890'),
('Дмитрий Орлов', '+79035567890');

INSERT INTO callback_computer_builds (name, phone_number, budget, usage_tasks, build_preferences) VALUES
('Олег Козлов', '+79036567890', 150000, 'Для игр', 'Высокая производительность, тихий'),
('Ирина Васильева', '+79037567890', 120000, 'Для работы', 'Надежность, много оперативной памяти'),
('Екатерина Морозова', '+79038567890', 80000, 'Для учебы', 'Портативность, строгий внешний вид'),
('Александр Смирнов', '+79039567890', 200000, 'Для графического дизайна', 'Мощный процессор, профессиональная видеокарта'),
('Нина Кузнецова', '+79040567890', 100000, 'Для дома', 'Большой корпус, много мест для накопителей'),
('Василий Петров', '+79041567890', 90000, 'Для программирования', 'Быстрый SSD, компактный'),
('Людмила Иванова', '+79042567890', 85000, 'Для видеоигр', 'Игровая видеокарта, высокая частота процессора');


-- Вставка хешированных паролей
INSERT INTO passwords (hashed_password)
VALUES
    (crypt('password01', gen_salt('bf'))),
    (crypt('password02', gen_salt('bf'))),
    (crypt('password03', gen_salt('bf'))),
    (crypt('password04', gen_salt('bf'))),
    (crypt('password05', gen_salt('bf'))),
    (crypt('password06', gen_salt('bf'))),
    (crypt('password07', gen_salt('bf'))),
    (crypt('password08', gen_salt('bf'))),
    (crypt('password09', gen_salt('bf'))),
    (crypt('password10', gen_salt('bf'))),
    (crypt('password11', gen_salt('bf'))),
    (crypt('password12', gen_salt('bf'))),
    (crypt('password13', gen_salt('bf'))),
    (crypt('password14', gen_salt('bf'))),
    (crypt('password15', gen_salt('bf')));


INSERT INTO employees (name, role, login, password_id, specialization) VALUES
('Иван Иванов', 'engineer', 'ivanov', 1, 'Ноутбук'),
('Елена Петрова', 'engineer', 'epetrova', 2, 'Материнская плата'),
('Алексей Сидоров', 'engineer', 'asidorov', 3, 'Видеокарта'),
('Марина Козлова', 'receptionist', 'mkozlova', 4, 'Прием заказов'),
('Дмитрий Морозов', 'service_owner', 'dmorozov', 5, 'Управление услугами'),
('Ольга Кузнецова', 'db_admin', 'okuznetsova', 6, 'Администрирование БД'),
('Сергей Николаев', 'engineer', 'snikolaev', 7, 'Компьютер'),
('Наталья Орлова', 'engineer', 'norlova', 8, 'Сборщик ПК'),
('Виктор Смирнов', 'engineer', 'vsmirnov', 9, 'Видеокарта'),
('Анна Васильева', 'engineer', 'avasilyeva', 10, 'Сборщик ПК'),
('Иван Васильев', 'engineer', 'ivasiliev', 11, 'Сборщик ПК'),
('Василий Антонов', 'engineer', 'vantonov', 12, 'Сборщик ПК');

INSERT INTO clients (name, contact_info) VALUES
('Анна Кузнецова','+79031234501'),
('Борис Смирнов','+79031234502'),
('Вера Петрова', '+79031234503'),
('Глеб Орлов', '+79031234504'),
('Дарья Морозова', '+79031234505'),
('Егор Козлов', '+79031234506'),
('Жанна Васильева', '+79031234507'),
('Зинаида Николаева', '+79031234508'),
('Игорь Сидоров', '+79031234509'),
('Кира Лебедева', '+79031234510'),
('Леонид Егоров', '+79031234511'),
('Мария Павлова', '+79031234512'),
('Никита Глебов', '+79031234513'),
('Олеся Кузнецова', '+79031234514');

INSERT INTO devices (type, model, serial_number) VALUES
('Ноутбук', 'Apple MacBook Pro 16', 'SN1001'),
('Компьютер', 'HP Omen 30L', 'SN1002'),
('Видеокарта', 'NVIDIA GeForce RTX 3080', 'SN1003'),
('Материнская плата', 'ASUS ROG Strix Z490-E', 'SN1004'),
('Ноутбук', 'Lenovo ThinkPad X1 Carbon', 'SN1005'),
('Компьютер', 'Dell XPS 8930', 'SN1006'),
('Видеокарта', 'AMD Radeon RX 6800 XT', 'SN1007'),
('Материнская плата', 'Gigabyte B550 AORUS MASTER', 'SN1008'),
('Ноутбук', 'Acer Predator Helios 300', 'SN1009'),
('Компьютер', 'Alienware Aurora R11', 'SN1010'),
('Видеокарта', 'NVIDIA GTX 1660 Super', 'SN1011'),
('Материнская плата', 'MSI MPG Z390 Gaming Edge AC', 'SN1012'),
('Ноутбук', 'Asus ROG Zephyrus G14', 'SN1013'),
('Компьютер', 'Corsair One i160', 'SN1014');

INSERT INTO orders (client_id, device_id, creation_date, cost) VALUES
(1, 1, '2023-10-01', 60000),
(2, 2, '2023-10-02', 120000),
(3, 3, '2023-10-03', 50000),
(4, 4, '2023-10-04', 75000),
(5, 5, '2023-10-05', 45000),
(6, 6, '2023-10-06', 85000),
(7, 7, '2023-10-07', 65000),
(8, 8, '2023-10-08', 95000),
(9, 9, '2023-10-09', 55000),
(10, 10, '2023-10-10', 35000),
(11, 11, '2023-10-11', 70000),
(12, 12, '2023-10-12', 80000),
(13, 13, '2023-10-13', 90000),
(14, 14, '2023-10-14', 100000);

INSERT INTO computer_builds (client_id, components, components_cost, creation_date, status) VALUES
(1, 'Процессор: AMD Ryzen 9 7950X, Материнская плата: ASUS ROG Strix X670-E, Видеокарта: NVIDIA GeForce RTX 4080 Ti, Оперативная память: 32GB DDR5 6200MHz, SSD: Samsung 980 Pro 1TB, Блок питания: Corsair RM850x, Корпус: NZXT H510', 350000, '2024-04-01', 'создан'),
(2, 'Процессор: Intel Core i9-14900K, Материнская плата: MSI MPG Z790 Gaming Carbon WiFi, Видеокарта: AMD Radeon RX 7900 XTX, Оперативная память: 32GB DDR5 7200MHz, SSD: Western Digital Black SN850 1TB, Блок питания: Seasonic Focus GX-850, Корпус: Fractal Design Meshify C', 300000, '2024-04-02', 'создан'),
(3, 'Процессор: Intel Core i7-14700KF, Материнская плата: Gigabyte Z790 Aorus Elite, Видеокарта: NVIDIA GeForce RTX 4070, Оперативная память: 64GB DDR5 6400MHz, SSD: Crucial P5 1TB, Блок питания: EVGA SuperNOVA 750 G5, Корпус: Corsair 4000D Airflow', 250000, '2024-04-03', 'создан'),
(4, 'Процессор: AMD Ryzen 5 5600X, Материнская плата: ASUS TUF Gaming B550-Plus, Видеокарта: NVIDIA GeForce RTX 4060 Ti, Оперативная память: 16GB DDR4 3600MHz, SSD: Samsung 970 Evo Plus 500GB, Блок питания: NZXT C650, Корпус: Phanteks Eclipse P400A', 200000, '2024-04-04', 'создан'),
(5, 'Процессор: AMD Ryzen 7 7800X3D, Материнская плата: MSI MAG B650 Tomahawk, Видеокарта: AMD Radeon RX 7700 XT, Оперативная память: 32GB DDR5 7200MHz, SSD: Kingston A2000 1TB, Блок питания: Be Quiet! Pure Power 11 700W, Корпус: Be Quiet! Pure Base 500DX', 220000, '2024-04-04', 'создан'),
(6, 'Процессор: Intel Core i5-13600KF, Материнская плата: Gigabyte B760 Vision G, Видеокарта: AMD Radeon RX 7700 XT, Оперативная память: 16GB DDR5 5600MHz, SSD: Crucial MX500 1TB, Блок питания: Corsair TXM Gold 650W, Корпус: Cooler Master MasterBox NR600', 180000, '2024-04-05', 'создан'),
(7, 'Процессор: Intel Core i5-13400, Материнская плата: ASRock B760M Pro4, Видеокарта: NVIDIA RTX 4060, Оперативная память: 16GB DDR5 5600MHz, SSD: Samsung 860 Evo 500GB, Блок питания: Seasonic S12III 500W, Корпус: Thermaltake Versa H18', 150000, '2024-04-06', 'создан');

CREATE OR REPLACE VIEW order_details AS
SELECT
    o.order_id AS order_number,                         -- Добавление номера заказа
    pgp_sym_decrypt(c.name::bytea, 'secret_key') AS client_name,
    d.type || ': ' || d.model AS device_model,          -- Объединение типа и модели устройства
    pgp_sym_decrypt(c.contact_info::bytea, 'secret_key') AS client_phone,  -- Добавление номера заказа к номеру телефона
    o.status AS order_status,
    e.name AS engineer_name
FROM
    orders o
    JOIN clients c ON o.client_id = c.client_id
    JOIN devices d ON o.device_id = d.device_id
    JOIN employees e ON o.engineer_id = e.employee_id;

CREATE OR REPLACE VIEW computer_build_details AS
SELECT
    cb.build_id AS build_number,
    pgp_sym_decrypt(c.name::bytea, 'secret_key') AS client_name,
    pgp_sym_decrypt(c.contact_info::bytea, 'secret_key') AS client_phone,
    cb.status AS build_status,
    e.name AS engineer_name,
    REPLACE(cb.components, ', ', E'\n') AS components  -- Замена запятых на символы новой строки
FROM
    computer_builds cb
    JOIN clients c ON cb.client_id = c.client_id
    JOIN employees e ON cb.engineer_id = e.employee_id;

CREATE OR REPLACE VIEW top_performers AS
SELECT
    e.name AS employee_name,
    e.role AS employee_role,
    e.specialization AS employee_specialization,
    COALESCE(MAX(o.status), 'Не определено') AS most_frequent_service,
    COUNT(o.order_id) + COUNT(cb.build_id) AS total_services_provided,
    COALESCE(SUM(o.cost), 0) + COALESCE(SUM(cb.components_cost), 0) AS total_revenue
FROM
    employees e
    LEFT JOIN orders o ON e.employee_id = o.engineer_id AND o.creation_date >= DATE_TRUNC('month', CURRENT_DATE) AND o.creation_date < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
    LEFT JOIN computer_builds cb ON e.employee_id = cb.engineer_id AND cb.creation_date >= DATE_TRUNC('month', CURRENT_DATE) AND cb.creation_date < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
GROUP BY
    e.employee_id, e.name, e.role, e.specialization
ORDER BY
    total_services_provided DESC;
