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

CREATE TABLE suppliers(
    supplier_id SERIAL PRIMARY KEY,
    type VARCHAR(30) NOT NULL CHECK ( type in ('Разъемы',
                                               'Конденсаторы',
                                               'Резисторы',
                                               'Видеопамять',
                                               'Чипы GPU',
                                               'Чипы СPU',
                                               'Чипсеты',
                                               'Сокеты',
                                               'Донорские компоненты',
                                               'Термопасты',
                                               'Термопаста с фазовым переходом',
                                               'Термопрокладки',
                                               'Жидкие термопрокладки',
                                               'Салфетки',
                                               'Обезжириватель',
                                               'Канифоль',
                                               'BGA шарики',
                                               'Медная проволока') ),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    contact_info TEXT NOT NULL
);

CREATE TABLE components (
    component_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    serial_number VARCHAR(100) UNIQUE NOT NULL,
    usage VARCHAR(100) NOT NULL
);

CREATE UNIQUE INDEX idx_serial_number ON components (serial_number);

CREATE TABLE supplies (
    supply_id SERIAL PRIMARY KEY,
    suppliers_id INT NOT NULL REFERENCES suppliers(supplier_id),
    component_id INT NOT NULL REFERENCES components(component_id),
    quantity INT NOT NULL CHECK ( quantity > 0 ),
    placing_date DATE NOT NULL DEFAULT CURRENT_DATE,
    departure_date DATE
);

CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL CHECK ( type IN ('Монитор',
                                               'Клавиатура',
                                               'Мышь',
                                               'Принтер',
                                               'Сканер',
                                               'Компьютер',
                                               'Роутер',
                                               'Хаб',
                                               'Источник питания',
                                               'Микроскоп',
                                               'Паяльник',
                                               'Cтол',
                                               'Кресло',
                                               'Коврик',
                                               'Лабораторный блок питания',
                                               'Натфиль',
                                               'Отвертка',
                                               'Настольная лампа') ),
    name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL CHECK ( quantity > 0 ),
    purchase_date DATE NOT NULL
);

-- Создание таблицы с заявками на обратный звонок по ремонту
CREATE TABLE callback_orders (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NOT NULL CHECK ( phone_number ~ '^8[0-9]{10}$' ),
    model VARCHAR(100) NOT NULL,
    defect VARCHAR(255) NOT NULL
);

--Создание таблицы с заявками на обратный звонок по сборкам компьютеров
CREATE TABLE callback_computer_builds (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NOT NULL CHECK ( phone_number ~ '^8[0-9]{10}$' ),
    budget DECIMAL(10, 2), -- Бюджет на сборку
    usage_tasks TEXT,       -- Задачи использования компьютера
    build_preferences TEXT  -- Предпочтения по сборке
);

-- Создание таблицы с паролями для сотрудников
CREATE TABLE passwords (
    password_id SERIAL PRIMARY KEY,
    hashed_password TEXT NOT NULL
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL CHECK ( name IN ('Инженер',
                                                'Приемщик',
                                                'Владелец',
                                                'Администратор баз данных') )
);

CREATE TABLE specializations (
    specialization_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL CHECK ( name IN ('Видеокарта',
                                                'Ноутбук',
                                                'Материнская плата',
                                                'Системный блок',
                                                'Сборщик системных блоков',
                                                'Владелец',
                                                'Приемщик',
                                                'Администратор баз данных') )
);

-- Создание таблицы с сотрудниками
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    password_id INT REFERENCES passwords(password_id),
    role_id INT NOT NULL REFERENCES roles(role_id),
    specialization_id INT NOT NULL REFERENCES specializations(specialization_id),
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    mname VARCHAR(50),
    passport_number TEXT,
    login VARCHAR(255) UNIQUE NOT NULL
);

-- Создание таблицы с клиентами
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL ,
    phone_number TEXT NOT NULL
);

-- Создание таблицы с техникой клиентов
CREATE TABLE devices (
    device_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    type VARCHAR(50) NOT NULL CHECK ( type IN( 'Ноутбук',
                                               'Видеокарта',
                                               'Материнская плата',
                                               'Системный блок' ) ),
    model VARCHAR(255) NOT NULL,
    serial_number VARCHAR(255) NOT NULL
);

-- Создание таблицы с заказами на ремонт
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    device_id INT NOT NULL REFERENCES devices(device_id),
    engineer_id INT NOT NULL REFERENCES employees(employee_id),
    defect VARCHAR(255),
    status VARCHAR(50) NOT NULL DEFAULT 'Создан'
        CHECK (status in ('Создан',
                          'В работе',
                          'Готов к выдаче',
                          'Завершен')),
    cost DECIMAL(10, 2),
    creation_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Создание таблицы с заказами на сборку системного блока
CREATE TABLE computer_builds (
    build_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    engineer_id INT NOT NULL REFERENCES employees(employee_id),
    components TEXT NOT NULL,
    components_cost DECIMAL(10, 2) NOT NULL,
    service_fee DECIMAL(10, 2) GENERATED ALWAYS AS (components_cost * 0.08) STORED,
    status VARCHAR(50) NOT NULL DEFAULT 'Создан'
        CHECK (status in ('Создан',
                          'В работе',
                          'Готов к выдаче',
                          'Завершен')),
    creation_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Создание таблицы с архивными заказами на ремонт
CREATE TABLE archived_orders (
    id INT NOT NULL,
    device_id INT REFERENCES devices(device_id),
    engineer_id INT REFERENCES employees(employee_id),
    status VARCHAR(50) NOT NULL CHECK (status in ('Завершен')),
    cost DECIMAL(10, 2),
    creation_date DATE NOT NULL,
    completion_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Создание таблицы с архивными заказами на сборку системного блока
CREATE TABLE archived_computer_builds (
    id INT NOT NULL,
    client_id INT REFERENCES clients(client_id),
    engineer_id INT REFERENCES employees(employee_id),
    components TEXT NOT NULL,
    components_cost DECIMAL(10, 2) NOT NULL,
    service_fee DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status in ('Завершен')),
    creation_date DATE NOT NULL,
    completion_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Создание роли и пользователей для каждой роли
CREATE ROLE receptionist;
CREATE ROLE engineer;
CREATE ROLE service_owner;
CREATE ROLE db_admin;

-- Назначение прав доступа
GRANT SELECT, INSERT, UPDATE ON orders, clients TO receptionist;
GRANT SELECT, UPDATE ON orders TO engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA repair_shop TO service_owner;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA repair_shop TO db_admin;

-- Триггер на щифрование данных клиента
CREATE OR REPLACE FUNCTION encrypt_client_data()
RETURNS TRIGGER AS $$
BEGIN
  -- Шифруем имя и контактные данные клиента перед вставкой
  NEW.name := pgp_sym_encrypt(NEW.name, 'secret_key');
  NEW.phone_number := pgp_sym_encrypt(NEW.phone_number, 'secret_key');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_encrypt_client_data
BEFORE INSERT ON repair_shop.clients
FOR EACH ROW EXECUTE FUNCTION encrypt_client_data();

CREATE OR REPLACE FUNCTION encrypt_employees_data()
RETURNS TRIGGER AS $$
BEGIN
  -- Шифруем имя и контактные данные клиента перед вставкой
  NEW.passport_number := pgp_sym_encrypt(NEW.passport_number, 'secret_key');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_encrypt_employees_data
BEFORE INSERT ON repair_shop.employees
FOR EACH ROW EXECUTE FUNCTION encrypt_employees_data();

CREATE OR REPLACE FUNCTION encrypt_supplier_data()
RETURNS TRIGGER AS $$
BEGIN
  NEW.name := pgp_sym_encrypt(NEW.name, 'secret_key');
  NEW.address := pgp_sym_encrypt(NEW.address, 'secret_key');
  NEW.contact_info := pgp_sym_encrypt(NEW.contact_info, 'secret_key');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_encrypt_supplier_data
BEFORE INSERT ON repair_shop.suppliers
FOR EACH ROW EXECUTE FUNCTION encrypt_supplier_data();


-- Создаем функции и триггеры для архивирования заказов
CREATE OR REPLACE FUNCTION archive_order() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Завершен' THEN
        INSERT INTO repair_shop.archived_orders (id, device_id, engineer_id, status, cost, creation_date)
        VALUES (NEW.order_id, NEW.device_id, NEW.engineer_id, NEW.status, NEW.cost, NEW.creation_date);
        DELETE FROM repair_shop.orders WHERE order_id = NEW.order_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_archive_order AFTER UPDATE ON repair_shop.orders
FOR EACH ROW WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'Завершен')
EXECUTE FUNCTION archive_order();

CREATE OR REPLACE FUNCTION archive_computer_build() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Завершен' THEN
        INSERT INTO repair_shop.archived_computer_builds (id, client_id, engineer_id, components, components_cost, service_fee, status, creation_date)
        VALUES (NEW.build_id, NEW.client_id, NEW.engineer_id, NEW.components, NEW.components_cost, NEW.service_fee, NEW.status, NEW.creation_date);
        DELETE FROM repair_shop.computer_builds WHERE build_id = NEW.build_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_archive_computer_build AFTER UPDATE ON repair_shop.computer_builds
FOR EACH ROW WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'Завершен')
EXECUTE FUNCTION archive_computer_build();

-- Новый триггер для назначения инженера на заказ по ремонту в зависимости от его специализации и загруженности
CREATE OR REPLACE FUNCTION assign_engineer() RETURNS TRIGGER AS $$
DECLARE
    selected_engineer_id INT;
    device_type VARCHAR(50);
BEGIN
    -- Получение типа устройства для нового заказа
    SELECT type INTO device_type FROM repair_shop.devices WHERE device_id = NEW.device_id;

    -- Выбор инженера с наименьшим количеством активных заказов, который специализируется на типе устройства заказа
    SELECT e.employee_id INTO selected_engineer_id
    FROM repair_shop.employees e
    LEFT JOIN (
        SELECT engineer_id, COUNT(*) AS active_orders
        FROM repair_shop.orders
        WHERE status IN ('Создан', 'В работе')
        GROUP BY engineer_id
    ) o ON e.employee_id = o.engineer_id
    WHERE e.specialization_id = (SELECT specialization_id FROM repair_shop.specializations WHERE name = device_type)
    ORDER BY COALESCE(o.active_orders, 0) ASC
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

-- Триггер для назначения инженера на заказ по ремонту
CREATE TRIGGER trigger_assign_engineer
BEFORE INSERT ON repair_shop.orders
FOR EACH ROW
EXECUTE FUNCTION assign_engineer();

-- Новый триггер для назначения инженера на заказ по ремонту в зависимости от его специализации и загруженности
CREATE OR REPLACE FUNCTION assign_assembler() RETURNS TRIGGER AS $$
DECLARE
    selected_engineer_id INT;
BEGIN

    -- Выбор инженера с наименьшим количеством активных заказов, который специализируется на типе устройства заказа
    SELECT e.employee_id INTO selected_engineer_id
    FROM repair_shop.employees e
    LEFT JOIN (
        SELECT engineer_id, COUNT(*) AS active_orders
        FROM repair_shop.orders
        WHERE status IN ('Создан', 'В работе')
        GROUP BY engineer_id
    ) o ON e.employee_id = o.engineer_id
    WHERE e.specialization_id = (SELECT specialization_id FROM repair_shop.specializations WHERE name = 'Сборщик системных блоков')
    ORDER BY COALESCE(o.active_orders, 0) ASC
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

-- Триггер для назначения инженера на заказ по ремонту
CREATE TRIGGER trigger_assign_engineer
BEFORE INSERT ON repair_shop.computer_builds
FOR EACH ROW
EXECUTE FUNCTION assign_assembler();


-- Вставка начальных данных (вставки для таблиц passwords, employees, clients и т.д. здесь не повторяются для краткости)

-- Вставка начальных данных для таблицы suppliers
INSERT INTO suppliers (type, name, address, contact_info) VALUES
('Разъемы', 'ООО "Разъем Сервис"', '123456, Россия, Москва, Тверская, дом 10', 'razem-service@example.com'),
('Конденсаторы', 'ЗАО "Конденсатор-М"', '654321, Россия, Санкт-Петербург, Невский, дом 5', 'condensator-m@example.com'),
('Резисторы', 'ИП "РезисторПром"', '234567, Россия, Новосибирск, Ленина, дом 15', 'resistor-prom@example.com'),
('Видеопамять', 'АО "Видеопамять Инк"', '765432, Россия, Екатеринбург, Мира, дом 8', 'videomemory-inc@example.com'),
('Чипы GPU', 'ООО "ГПУ Комплект"', '876543, Россия, Казань, Победы, дом 20', 'gpu-komplekt@example.com');

-- Вставка начальных данных для таблицы components
INSERT INTO components (name, serial_number, usage) VALUES
('Разъем HDMI', 'HDMI-123456', 'Видеокарты'),
('Конденсатор 10uF', 'C10uF-654321', 'Материнские платы'),
('Резистор 100 Ом', 'R100-234567', 'Ноутбуки'),
('Видеопамять 2GB', 'VRAM2GB-765432', 'Видеокарты'),
('Чип GPU RTX3060', 'GPU3060-876543', 'Видеокарты');

-- Вставка начальных данных для таблицы supplies
INSERT INTO supplies (suppliers_id, component_id, quantity, departure_date) VALUES
(1, 1, 100, '2024-05-01'),
(2, 2, 200, '2024-05-02'),
(3, 3, 150, '2024-05-03'),
(4, 4, 120, '2024-05-04'),
(5, 5, 80, '2024-05-05');

-- Вставка начальных данных для таблицы equipment
INSERT INTO equipment (type, name, quantity, purchase_date) VALUES
('Монитор', 'Samsung', 10, '2024-01-10'),
('Клавиатура', 'Logitech', 15, '2024-02-12'),
('Мышь', 'Razer', 20, '2024-03-15'),
('Принтер', 'HP', 5, '2024-04-10'),
('Сканер', 'Canon', 8, '2024-05-08');

-- Вставка начальных данных для таблицы callback_orders
INSERT INTO callback_orders (name, phone_number, model, defect) VALUES
('Иван Иванов', '89031234567', 'ASUS Laptop', 'Не включается'),
('Петр Петров', '89039876543', 'MSI Videocard', 'Артефакты на экране'),
('Сергей Сергеев', '89035432123', 'Gigabyte Motherboard', 'Не работает USB'),
('Алексей Алексеев', '89037654321', 'Dell Laptop', 'Синий экран смерти'),
('Николай Николаев', '89032121212', 'HP Laptop', 'Перегрев');

-- Вставка начальных данных для таблицы callback_computer_builds
INSERT INTO callback_computer_builds (name, phone_number, budget, usage_tasks, build_preferences) VALUES
('Михаил Михайлов', '89035556677', 50000, 'Игры, работа', 'NVidia, Intel'),
('Дмитрий Дмитриев', '89038889900', 70000, '3D моделирование', 'AMD, SSD 1TB'),
('Андрей Андреев', '89036661122', 45000, 'Офисная работа', 'Минимальный шум'),
('Игорь Игорев', '89037773344', 60000, 'Видео монтаж', 'Многоядерный процессор, 16GB RAM'),
('Роман Романов', '89039994455', 80000, 'Программирование', 'Dual Monitor Support, 32GB RAM');

-- Вставка начальных данных для таблицы passwords с дополнительными сотрудниками
INSERT INTO passwords (hashed_password) VALUES
(crypt('password1', gen_salt('bf'))),
(crypt('password2', gen_salt('bf'))),
(crypt('password3', gen_salt('bf'))),
(crypt('password4', gen_salt('bf'))),
(crypt('password5', gen_salt('bf'))),
(crypt('password6', gen_salt('bf'))),
(crypt('password7', gen_salt('bf'))),
(crypt('password8', gen_salt('bf'))),
(crypt('password9', gen_salt('bf'))),
(crypt('password10', gen_salt('bf'))),
(crypt('password11', gen_salt('bf'))),
(crypt('password12', gen_salt('bf'))),
(crypt('password13', gen_salt('bf'))),
(crypt('password14', gen_salt('bf'))),
(crypt('password15', gen_salt('bf'))),
(crypt('password16', gen_salt('bf'))),
(crypt('password17', gen_salt('bf'))),
(crypt('password18', gen_salt('bf'))),
(crypt('password19', gen_salt('bf'))),
(crypt('password20', gen_salt('bf'))),
(crypt('password21', gen_salt('bf'))),
(crypt('password22', gen_salt('bf'))),
(crypt('password23', gen_salt('bf'))),
(crypt('password24', gen_salt('bf')));

-- Вставка начальных данных для таблицы roles
INSERT INTO roles (name) VALUES
('Инженер'),
('Приемщик'),
('Владелец'),
('Администратор баз данных');

-- Вставка начальных данных для таблицы specializations
INSERT INTO specializations (name) VALUES
('Видеокарта'),
('Ноутбук'),
('Материнская плата'),
('Системный блок'),
('Сборщик системных блоков'),
('Владелец'),
('Приемщик'),
('Администратор баз данных');

-- Вставка начальных данных для таблицы employees с дополнительными сотрудниками
INSERT INTO employees (password_id, role_id, specialization_id, fname, lname, mname, passport_number, login) VALUES
-- Инженеры по видеокартам
(1, 1, 1, 'Андрей', 'Андреев', 'Андреевич', '1234567890', 'a.andreev'),
(2, 1, 1, 'Сергей', 'Сергеев', 'Сергеевич', '2234567890', 's.sergeev'),
(3, 1, 1, 'Геннадий', 'Владимиров', 'Владимирович', '3234567890', 'g.vladimirov'),

-- Инженеры по ноутбукам
(4, 1, 2, 'Борис', 'Борисов', 'Борисович', '2345678901', 'b.borisov'),
(5, 1, 2, 'Алексей', 'Алексеев', 'Алексеевич', '3345678901', 'a.alekseev'),
(6, 1, 2, 'Михаил', 'Михайлов', 'Михайлович', '4345678901', 'm.mikhailov'),

-- Инженеры по материнским платам
(7, 1, 3, 'Владимир', 'Владимиров', 'Владимирович', '3456789012', 'v.vladimirov'),
(8, 1, 3, 'Иван', 'Иванов', 'Иванович', '4456789012', 'i.ivanov'),
(9, 1, 3, 'Дмитрий', 'Дмитриев', 'Дмитриевич', '5456789012', 'd.dmitriev'),

-- Инженеры по системным блокам
(10, 1, 4, 'Геннадий', 'Геннадиев', 'Геннадиевич', '4567890123', 'g.gennadiev'),
(11, 1, 4, 'Николай', 'Николаев', 'Николаевич', '5567890123', 'n.nikolaev'),
(12, 1, 4, 'Анатолий', 'Анатольев', 'Анатольевич', '6567890123', 'a.anatoliev'),

-- Сборщики системных блоков
(13, 1, 5, 'Вячеслав', 'Дмитриев', 'Дмитриевич', '5678901234', 'v.dmitriev'),
(14, 1, 5, 'Олег', 'Олегов', 'Олегович', '6678901234', 'o.olegov'),
(15, 1, 5, 'Евгений', 'Евгеньев', 'Евгеньевич', '7678901234', 'e.evgeniev'),

-- Владелец
(16, 3, 6, 'Максим', 'Максимов', 'Максимович', '8678901234', 'm.maksimov'),
(17, 3, 6, 'Виталий', 'Витальев', 'Витальевич', '9678901234', 'v.vitaliev'),
(18, 3, 6, 'Роман', 'Романов', 'Романович', '1067890123', 'r.romanov'),

-- Приемщики
(19, 2, 7, 'Егор', 'Егоров', 'Егорович', '1178901234', 'e.egorov'),
(20, 2, 7, 'Петр', 'Петров', 'Петрович', '1278901234', 'p.petrov'),
(21, 2, 7, 'Федор', 'Федоров', 'Федорович', '1378901234', 'f.fedorov'),

-- Администраторы баз данных
(22, 4, 8, 'Константин', 'Константинов', 'Константинович', '1478901234', 'k.konstantinov'),
(23, 4, 8, 'Юрий', 'Юрьев', 'Юрьевич', '1578901234', 'y.yurev'),
(24, 4, 8, 'Вячеслав', 'Вячеславов', 'Вячеславович', '1678901234', 'v.vyacheslavov');

-- Вставка начальных данных для таблицы clients
INSERT INTO clients (name, phone_number) VALUES
(pgp_sym_encrypt('Александр Александров', 'secret_key'), pgp_sym_encrypt('89031234567', 'secret_key')),
(pgp_sym_encrypt('Евгений Евгеньев', 'secret_key'), pgp_sym_encrypt('89039876543', 'secret_key')),
(pgp_sym_encrypt('Василий Васильев', 'secret_key'), pgp_sym_encrypt('89035432123', 'secret_key')),
(pgp_sym_encrypt('Илья Ильин', 'secret_key'), pgp_sym_encrypt('89037654321', 'secret_key')),
(pgp_sym_encrypt('Максим Максимов', 'secret_key'), pgp_sym_encrypt('89032121212', 'secret_key'));

-- Вставка начальных данных для таблицы devices
INSERT INTO devices (client_id, type, model, serial_number) VALUES
(1, 'Ноутбук', 'ASUS ROG', '123ASUS456'),
(2, 'Видеокарта', 'MSI GTX 1060', '234MSI567'),
(3, 'Материнская плата', 'Gigabyte Z370', '345GIG456'),
(4, 'Ноутбук', 'Dell Inspiron', '456DELL789'),
(5, 'Ноутбук', 'HP Pavilion', '567HP678');

-- Вставка начальных данных для таблицы orders
INSERT INTO orders (device_id, engineer_id, status, cost, creation_date) VALUES
(1, 1, 'Создан', 5000.00, '2024-05-01'),
(2, 2, 'В работе', 7000.00, '2024-05-02'),
(3, 3, 'Готов к выдаче', 3000.00, '2024-05-03'),
(4, 1, 'Завершен', 4500.00, '2024-05-04'),
(5, 2, 'Создан', 2500.00, '2024-05-05');

-- Вставка начальных данных для таблицы computer_builds с актуальными данными и требуемым форматом
INSERT INTO computer_builds (client_id, engineer_id, components, components_cost, status, creation_date) VALUES
(1, 1,
    'Процессор: Intel Core i5-14600, Материнская плата: ASUS ROG Strix Z790-E, Видеокарта: MSI GeForce RTX 4060 Ventus 2X, Оперативная память: Corsair Vengeance LPX 16GB DDR5-5200, Охлаждение процессора: Noctua NH-D15, Накопители: SSD Samsung 980 Pro 1TB, Блок питания: Corsair RM850x, Корпус: NZXT H510',
    90000.00,
    'Создан',
    '2024-05-15'),
(2, 2,
    'Процессор: AMD Ryzen 5 7600X, Материнская плата: MSI B650 Tomahawk, Видеокарта: ASUS ROG Strix GeForce RTX 4070, Оперативная память: G.Skill Trident Z RGB 32GB DDR5-6000, Охлаждение процессора: Cooler Master Hyper 212 RGB, Накопители: SSD WD Black SN850 2TB, Блок питания: Seasonic Focus GX-850, Корпус: Fractal Design Meshify C',
    130000.00,
    'В работе',
    '2024-05-15'),
(3, 3,
    'Процессор: Intel Core i7-14700K, Материнская плата: Gigabyte Z790 AORUS Ultra, Видеокарта: Gigabyte GeForce RTX 4080 Vision OC, Оперативная память: Kingston Fury Beast 64GB DDR5-6000, Охлаждение процессора: NZXT Kraken X73, Накопители: SSD Crucial P5 Plus 2TB, Блок питания: EVGA SuperNOVA 850 G5, Корпус: Lian Li PC-O11 Dynamic',
    160000.00,
    'Готов к выдаче',
    '2024-05-15'),
(4, 4,
    'Процессор: AMD Ryzen 9 7950X, Материнская плата: ASUS ROG Crosshair VIII Hero, Видеокарта: Zotac GeForce RTX 4090 Trinity, Оперативная память: Corsair Dominator Platinum RGB 128GB DDR5-6000, Охлаждение процессора: Arctic Liquid Freezer II 360, Накопители: SSD Samsung 990 Pro 2TB, Блок питания: be quiet! Dark Power Pro 12 1200W, Корпус: Corsair 7000D Airflow',
    270000.00,
    'Завершен',
    '2024-05-15'),
(5, 5,
    'Процессор: Intel Core i9-14900K, Материнская плата: ASUS ROG Maximus Z790 Hero, Видеокарта: EVGA GeForce RTX 4090 FTW3 Ultra, Оперативная память: G.Skill Ripjaws V 64GB DDR5-6000, Охлаждение процессора: Corsair iCUE H150i Elite Capellix, Накопители: SSD Kingston KC3000 2TB, Блок питания: Corsair AX1600i, Корпус: Phanteks Eclipse P600S',
    320000.00,
    'Создан',
    '2024-05-15');