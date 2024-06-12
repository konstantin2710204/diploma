-- Удаление баз данных если она существует
DROP DATABASE IF EXISTS repair_shop;

-- Создание базы данных
CREATE DATABASE repair_shop;

-- Переход в базу данных
\c repair_shop;

-- Создание схемы, переход на схему
CREATE SCHEMA repair_shop;
SET search_path TO 'repair_shop';

-- Подключение необходимых расширений, если они не подключены
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Создание таблицы поставщиков компонентов
CREATE TABLE suppliers(
    supplier_id SERIAL PRIMARY KEY,  -- Идентификатор поставщика
    type VARCHAR(30) NOT NULL CHECK (type in (
        'Разъемы', 'Конденсаторы', 'Резисторы', 'Видеопамять', 'Чипы GPU', 'Чипы СPU',
        'Чипсеты', 'Сокеты', 'Донорские компоненты', 'Термопасты', 'Термопаста с фазовым переходом',
        'Термопрокладки', 'Жидкие термопрокладки', 'Салфетки', 'Обезжириватель', 'Канифоль',
        'BGA шарики', 'Медная проволока'
    )), -- Тип поставляемого компонента
    name TEXT NOT NULL,  -- Наименование организации-поставщика
    address TEXT NOT NULL, -- Адрес организации-поставщика
    contact_info TEXT NOT NULL  -- Контактная информация организации-поставщика
);

-- Создание таблицы компонентов
CREATE TABLE components (
    component_id SERIAL PRIMARY KEY,  -- Идентификатор компонента
    name VARCHAR(50) NOT NULL,  -- Наименование компонента
    serial_number VARCHAR(100) UNIQUE NOT NULL,  -- Серийный номер компонента
    usage VARCHAR(100) NOT NULL  -- Для чего используется компонент
);

-- Создание уникального индекса на серийный номер компонента
CREATE UNIQUE INDEX idx_serial_number ON components (serial_number);

-- Создание таблицы поставок
CREATE TABLE supplies (
    supply_id SERIAL PRIMARY KEY,  -- Идентификатор поставки
    suppliers_id INT NOT NULL REFERENCES suppliers(supplier_id),  -- Идентификатор поставщика
    component_id INT NOT NULL REFERENCES components(component_id),  -- Идентификатор компонента
    quantity INT NOT NULL CHECK ( quantity > 0 ),  -- Количество компонентов в поставке
    placing_date DATE NOT NULL DEFAULT CURRENT_DATE,  -- Дата оформления поставки
    departure_date DATE  -- Дата прибытия поставки
);

-- Создание таблицы оборудования сервисного центра
CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,  -- Идентификатор единицы оборудования сервисного центра
    type VARCHAR(50) NOT NULL CHECK (type IN (
        'Монитор', 'Клавиатура', 'Мышь', 'Принтер', 'Сканер', 'Компьютер', 'Роутер', 'Хаб',
        'Источник питания', 'Микроскоп', 'Паяльник', 'Cтол', 'Кресло', 'Коврик',
        'Лабораторный блок питания', 'Натфиль', 'Отвертка', 'Настольная лампа'
    )),  -- Тип оборудования сервисного центра
    name VARCHAR(50) NOT NULL,  -- Наименования единицы оборудование сервисного центра
    quantity INT NOT NULL CHECK ( quantity > 0 ),  -- Количество единиц оборудования
    purchase_date DATE NOT NULL  -- Дата покупки единицы оборудования
);

-- Создание таблицы заявок клиентов на обратный звонок по ремонту техники
CREATE TABLE callback_orders (
    id SERIAL PRIMARY KEY,  -- Идентификатор заявки на обратный звонок по вопросам ремонта
    name VARCHAR(255) NOT NULL,  -- Имя клиента
    phone_number VARCHAR(50) NOT NULL CHECK ( phone_number ~ '^8[0-9]{10}$' ),  -- Номер телефона клиента
    model VARCHAR(100) NOT NULL,  -- Модель устройства
    defect VARCHAR(255) NOT NULL  -- Дефект устройства
);

-- Создание таблицы на обратный звонок по сборке системных блоков
CREATE TABLE callback_computer_builds (
    id SERIAL PRIMARY KEY,  -- Идентификатор заявки на обратный звонок по вопросам сборки системного блока
    name VARCHAR(255) NOT NULL,  -- Имя клиента
    phone_number VARCHAR(50) NOT NULL CHECK ( phone_number ~ '^8[0-9]{10}$' ), -- Номер телефона клиента
    budget DECIMAL(10, 2), -- Бюджет на сборку системного блока
    usage_tasks TEXT,       -- Задачи использования компьютера
    build_preferences TEXT  -- Предпочтения по сборке
);

-- Создание таблицы с паролями сотрудников
CREATE TABLE passwords (
    password_id SERIAL PRIMARY KEY,  -- Идентификатор пароля
    hashed_password TEXT NOT NULL -- Хеш пароля
);

-- Создание таблицы должностей для сотрудников
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,  -- Идентификатор должности
    name VARCHAR(100) NOT NULL CHECK (name IN (
        'Инженер', 'Приемщик', 'Владелец', 'Администратор баз данных'
    ))  -- Должность
);

-- Создание таблицы специализаций для сотрудников
CREATE TABLE specializations (
    specialization_id SERIAL PRIMARY KEY,  -- Идентификатор специализации
    name VARCHAR(100) NOT NULL CHECK (name IN (
        'Видеокарта', 'Ноутбук', 'Материнская плата', 'Системный блок',
        'Сборщик системных блоков', 'Владелец', 'Приемщик', 'Администратор баз данных'
    )) -- Специализация
);

-- Создание таблицы сотрудников
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,  -- Идентификатор сотрудника
    password_id INT REFERENCES passwords(password_id),  -- Идентификатор пароля
    role_id INT NOT NULL REFERENCES roles(role_id),  -- Идентификатор должности
    specialization_id INT NOT NULL REFERENCES specializations(specialization_id),  -- Идентификтор специализации
    fname VARCHAR(50) NOT NULL,  -- Имя сотрудника
    lname VARCHAR(50) NOT NULL,  -- Фамилия сотрудника
    mname VARCHAR(50),  -- Отчество сотрудника (если есть)
    passport_number TEXT, -- Номер паспорта сотрудника
    login VARCHAR(255) UNIQUE NOT NULL -- Логин учетной записи сотрудника
);

-- Создание таблицы клиентов
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,  -- Идентификатор клиента
    name TEXT NOT NULL,  -- Имя клиента
    phone_number TEXT NOT NULL CHECK ( phone_number ~ '^8[0-9]{10}$' )  -- Номер телефона клиента
);

-- Саздание таблицы устройств клиентов
CREATE TABLE devices (
    device_id SERIAL PRIMARY KEY,  -- Идентификатор устройства
    client_id INT NOT NULL REFERENCES clients(client_id),  -- Идентификатор клиента
    type VARCHAR(50) NOT NULL CHECK (type IN (
        'Ноутбук', 'Видеокарта', 'Материнская плата', 'Системный блок'
    )),  -- Тип устройства
    model VARCHAR(255) NOT NULL,  -- Модель устройства
    serial_number VARCHAR(255) NOT NULL  -- Серийный номер устройства
);

-- Создание таблицы с текущими заказами
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,  -- Идентификатор заказа (номер заказа)
    device_id INT NOT NULL REFERENCES devices(device_id),  -- Идентификатор устройства
    client_id INT NOT NULL REFERENCES clients(client_id),  -- Идентификатор клиента
    engineer_id INT NOT NULL REFERENCES employees(employee_id),  -- Идентификатор инженера (сотрудника)
    defect VARCHAR(255),  -- Дефект устройства
    status VARCHAR(50) NOT NULL DEFAULT 'Создан' CHECK (status in (
        'Создан', 'В работе', 'Готов к выдаче', 'Завершен'
    )),  -- Статус выполнения заказа
    cost DECIMAL(10, 2),  -- Стоимость работ
    creation_date DATE NOT NULL DEFAULT CURRENT_DATE  -- Дата создания заказа
);

-- Создание таблицы с текущими сборками компьютеров
CREATE TABLE computer_builds (
    build_id SERIAL PRIMARY KEY,  -- Идентификатор сборки системного блока (номер заказа)
    client_id INT NOT NULL REFERENCES clients(client_id),  -- Идентификатор клиента
    engineer_id INT NOT NULL REFERENCES employees(employee_id),  -- Идентификатор инженера (сотрудника)
    components TEXT NOT NULL,  -- Комплектующие для системного блока
    components_cost DECIMAL(10, 2) NOT NULL,  -- Стоимость комплектующих
    service_fee DECIMAL(10, 2) GENERATED ALWAYS AS (components_cost * 0.08) STORED,  -- Стоимость услуги сборки
    status VARCHAR(50) NOT NULL DEFAULT 'Создан' CHECK (status in (
        'Создан', 'В работе', 'Готов к выдаче', 'Завершен'
    )),  -- Статус выполнения заказа
    creation_date DATE NOT NULL DEFAULT CURRENT_DATE  -- Дата создания заказа
);

-- Создание таблицы с архивными заказами
CREATE TABLE archived_orders (
    id INT NOT NULL,  -- Номер заказа
    device_id INT REFERENCES devices(device_id),  -- Идентификатор устройства
    client_id INT REFERENCES clients(client_id),  -- Идентификатор клиента
    engineer_id INT REFERENCES employees(employee_id),  -- Идентификатор инженера (сотрудника)
    status VARCHAR(50) NOT NULL CHECK (status in (
        'Завершен'
    )),  -- Статус заказа (всегда 'Завершен')
    cost DECIMAL(10, 2),  -- Стоимость работ
    creation_date DATE NOT NULL,  -- Дата создания заказа
    completion_date DATE NOT NULL DEFAULT CURRENT_DATE  -- Дата завершнения заказа
);

-- Создание таблицы с архивными сборками компьютеров
CREATE TABLE archived_computer_builds (
    id INT NOT NULL,  -- Номер сборки
    client_id INT REFERENCES clients(client_id),  -- Идентификатор клиента
    engineer_id INT REFERENCES employees(employee_id),  -- Идентификатор инженера (сотрудника)
    components TEXT NOT NULL,  -- Комплектующие для системного блока
    components_cost DECIMAL(10, 2) NOT NULL,  -- Стоимость комплектующих
    service_fee DECIMAL(10, 2) NOT NULL,  -- Стоимость услуги сборки
    status VARCHAR(50) NOT NULL CHECK (status in (
        'Завершен'
    )),  -- Статус заказа (всегда 'Завершен')
    creation_date DATE NOT NULL,  -- Дата создания заказа
    completion_date DATE NOT NULL DEFAULT CURRENT_DATE  -- Дата завершения заказа
);

-- Создания функции шифрования данных паспорта сотрудников для триггера, используя pgcrypto
CREATE OR REPLACE FUNCTION encrypt_employees_data()
RETURNS TRIGGER AS $$
BEGIN
  NEW.passport_number := pgp_sym_encrypt(NEW.passport_number, 'secret_key');  -- Шифрования стоблца с номером паспорта
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера для функции encrypt_employees_data(),
-- выполняемого перед вставкой данных
CREATE TRIGGER trigger_encrypt_employees_data
BEFORE INSERT ON repair_shop.employees
FOR EACH ROW EXECUTE FUNCTION encrypt_employees_data();

-- Создание функции архивации заказа для триггера
CREATE OR REPLACE FUNCTION archive_order() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Завершен' THEN  -- Если статус заказа становится 'Завершен'
        INSERT INTO repair_shop.archived_orders (id, device_id, engineer_id, status, cost, creation_date)   -- Вставка данных
        VALUES (NEW.order_id, NEW.device_id, NEW.engineer_id, NEW.status, NEW.cost, NEW.creation_date);     -- в таблицу archived_orders
        DELETE FROM repair_shop.orders WHERE order_id = NEW.order_id;  -- Удаление строки с заказом, статус которого стал 'Завершен'
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера для функции archive_order(),
-- выполняемого перед обновлением данных в строке таблицы orders
CREATE TRIGGER trigger_archive_order AFTER UPDATE ON repair_shop.orders
FOR EACH ROW WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'Завершен')
EXECUTE FUNCTION archive_order();

-- Создание функции для архивации сборки системного блока
CREATE OR REPLACE FUNCTION archive_computer_build() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Завершен' THEN  -- Если статус заказа становится 'Завершен'
        INSERT INTO repair_shop.archived_computer_builds (id, client_id, engineer_id, components, components_cost, service_fee, status, creation_date)  -- Вставка данных
        VALUES (NEW.build_id, NEW.client_id, NEW.engineer_id, NEW.components, NEW.components_cost, NEW.service_fee, NEW.status, NEW.creation_date);     -- в таблицу archived_computer_builds
        DELETE FROM repair_shop.computer_builds WHERE build_id = NEW.build_id;  -- Удаление строки с заказом, статус которого стал 'Завершен'
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера для функции archive_computer_build(),
-- выполняемого перед обновлением данных в строке таблицы computer_builds
CREATE TRIGGER trigger_archive_computer_build AFTER UPDATE ON repair_shop.computer_builds
FOR EACH ROW WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'Завершен')
EXECUTE FUNCTION archive_computer_build();

-- Создание функции для назначения инженера на заказ по ремонту техники
CREATE OR REPLACE FUNCTION assign_engineer() RETURNS TRIGGER AS $$
DECLARE
    selected_engineer_id INT;  -- Выбранный инженер
    device_type VARCHAR(50);  -- Тип устройства
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

    IF selected_engineer_id IS NULL THEN  -- Если инженер не был найден
        RAISE EXCEPTION 'Не найден инженер с необходимой специализацией: %', device_type;
    ELSE  -- В иных случаях
        NEW.engineer_id := selected_engineer_id;  -- Назначение найденного инженера на заказ
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера для функции assign_engineer(),
-- выполняемого перед вставкой данных в таблицу orders
CREATE TRIGGER trigger_assign_engineer
BEFORE INSERT ON repair_shop.orders
FOR EACH ROW
EXECUTE FUNCTION assign_engineer();

-- Создание функции для назначения сборщика на заказ по сборке системного блока
CREATE OR REPLACE FUNCTION assign_assembler() RETURNS TRIGGER AS $$
DECLARE
    selected_engineer_id INT;  -- Выбранный инженер
BEGIN

    SELECT e.employee_id INTO selected_engineer_id      -- Выборка инженера
    FROM repair_shop.employees e
    LEFT JOIN (
        SELECT engineer_id, COUNT(*) AS active_orders
        FROM repair_shop.orders
        WHERE status IN ('Создан', 'В работе')
        GROUP BY engineer_id                            -- у которого нет заказов на сборку
    ) o ON e.employee_id = o.engineer_id
    WHERE e.specialization_id = (
        SELECT specialization_id
        FROM repair_shop.specializations
        WHERE name = 'Сборщик системных блоков'         -- и у которого специалициализация 'Сборщик системных блоков'
    )
    ORDER BY COALESCE(o.active_orders, 0) ASC
    LIMIT 1;

    IF selected_engineer_id IS NULL THEN  -- Если инженер не был найден
        RAISE EXCEPTION 'Не найден сборщик';
    ELSE  -- В остальных случаях
        NEW.engineer_id := selected_engineer_id;  -- Назначение найденного инженера заказу
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера для функции assign_assembler(),
-- выполняемого перед вставкой данных в таблицу orders
CREATE TRIGGER trigger_assign_engineer
BEFORE INSERT ON repair_shop.computer_builds
FOR EACH ROW
EXECUTE FUNCTION assign_assembler();

-- Вставка данных в таблицу suppliers
INSERT INTO repair_shop.suppliers (type, name, address, contact_info) VALUES
('Разъемы', 'Mouser Electronics', '1000 N Main St, Mansfield, TX 76063, USA', 'info@mouser.com'),
('Конденсаторы', 'Digi-Key Electronics', '701 Brooks Ave S, Thief River Falls, MN 56701, USA', 'sales@digikey.com'),
('Резисторы', 'RS Components', 'Birchington Road, Corby, Northants, NN17 9RS, UK', 'sales@rs-components.com'),
('Видеопамять', 'Micron Technology', '8000 S Federal Way, Boise, ID 83716, USA', 'support@micron.com'),
('Чипы GPU', 'NVIDIA Corporation', '2788 San Tomas Expy, Santa Clara, CA 95051, USA', 'info@nvidia.com'),
('Чипы СPU', 'Intel Corporation', '2200 Mission College Blvd, Santa Clara, CA 95054, USA', 'support@intel.com'),
('Чипсеты', 'Qualcomm', '5775 Morehouse Dr, San Diego, CA 92121, USA', 'info@qualcomm.com'),
('Сокеты', 'Foxconn', 'No. 2, Zijinghua Road, Longhua District, Shenzhen, China', 'info@foxconn.com'),
('Донорские компоненты', 'Arrow Electronics', '7459 S. Lima Street, Englewood, CO 80112, USA', 'support@arrow.com'),
('Термопасты', 'Arctic', 'Sihlbruggstrasse 144, 6340 Baar, Switzerland', 'support@arctic.ac'),
('Термопаста с фазовым переходом', 'Cooler Master', '2F, No. 788-1, Zhongzheng Rd, Zhonghe District, New Taipei City, Taiwan', 'support@coolermaster.com'),
('Термопрокладки', 'Thermaltake', '5F, No.18, Jihu Road, Neihu District, Taipei City, Taiwan', 'support@thermaltake.com'),
('Жидкие термопрокладки', 'Noctua', 'Rennweg 1, 6020 Innsbruck, Austria', 'support@noctua.at'),
('Салфетки', 'Kimberly-Clark', '2100 Winchester Road, Neenah, WI 54956, USA', 'info@kcc.com'),
('Обезжириватель', 'CRC Industries', '885 Louis Drive, Warminster, PA 18974, USA', 'sales@crcindustries.com'),
('Канифоль', 'Kester', '800 W. Thorndale Ave, Itasca, IL 60143, USA', 'support@kester.com'),
('BGA шарики', 'Amtech', '15 Jonathan Drive, Suite 4, Brockton, MA 02301, USA', 'sales@amtechsolder.com'),
('Медная проволока', 'Elektrisola', '271 Industrial Park Road, Boscawen, NH 03303, USA', 'info@elektrisola.com'),
('Резисторы', 'Vishay Intertechnology', '63 Lincoln Highway, Malvern, PA 19355, USA', 'support@vishay.com'),
('Конденсаторы', 'TDK Corporation', '1-13-1 Nihonbashi, Chuo-ku, Tokyo 103-8272, Japan', 'support@tdk.com');

-- Вставка данных в таблицу components
INSERT INTO repair_shop.components (name, serial_number, usage) VALUES
('Разъем USB 3.0', 'USB3-123456', 'Подключение периферийных устройств'),
('Конденсатор 100uF', 'CAP-100UF-7890', 'Стабилизация напряжения'),
('Резистор 1kOhm', 'RES-1K-4567', 'Ограничение тока'),
('GDDR5 2GB', 'GDDR5-2GB-3456', 'Видеопамять для видеокарт'),
('NVIDIA GeForce GTX 1050', 'GPU-GTX1050-1234', 'Графический процессор'),
('Intel Core i5-9600K', 'CPU-I5-9600K-2345', 'Процессор для настольных ПК'),
('Чипсет Intel Z390', 'CHIPSET-Z390-6789', 'Чипсет для материнских плат'),
('Сокет LGA1151', 'SOCKET-LGA1151-5678', 'Сокет для процессоров Intel'),
('Чип донорский', 'DONOR-CHIP-6789', 'Используется для ремонта'),
('Термопаста Arctic MX-4', 'TP-MX4-8901', 'Термопаста для улучшения теплоотвода'),
('Термопаста Coollaboratory Liquid Pro', 'TPLP-5678', 'Термопаста с фазовым переходом'),
('Термопрокладка Fujipoly 1mm', 'TPG-FUJIPOLY-1MM-2345', 'Термопрокладка для улучшения теплоотвода'),
('Жидкая термопрокладка Arctic Liquid Metal', 'LTP-ARCTIC-6789', 'Жидкая термопрокладка для улучшения теплоотвода'),
('Салфетка Kimtech Science', 'WIPES-KIMTECH-4567', 'Очистка и обезжиривание'),
('Обезжириватель CRC Lectra Clean', 'DEGREASER-CRC-1234', 'Обезжиривание компонентов'),
('Канифоль Kester', 'ROSIN-KESTER-2345', 'Флюс для пайки'),
('BGA шарики 0.6mm', 'BGA-BALLS-0.6-3456', 'Используются при реболлинге BGA чипов'),
('Медная проволока 0.5mm', 'COPPER-WIRE-0.5-4567', 'Пайка и ремонт'),
('Конденсатор 10uF', 'CAP-10UF-7891', 'Стабилизация напряжения'),
('Резистор 10kOhm', 'RES-10K-5679', 'Ограничение тока'),
('GDDR5 4GB', 'GDDR5-4GB-8902', 'Видеопамять для видеокарт'),
('NVIDIA GeForce GTX 1650', 'GPU-GTX1650-6789', 'Графический процессор'),
('Intel Core i7-9700K', 'CPU-I7-9700K-7892', 'Процессор для настольных ПК'),
('Чипсет Intel B360', 'CHIPSET-B360-8901', 'Чипсет для материнских плат'),
('Сокет AM4', 'SOCKET-AM4-9012', 'Сокет для процессоров AMD'),
('Термопаста Noctua NT-H1', 'TP-NT-H1-2346', 'Термопаста для улучшения теплоотвода'),
('Термопрокладка Arctic 1.5mm', 'TPG-ARCTIC-1.5MM-3457', 'Термопрокладка для улучшения теплоотвода'),
('Жидкая термопрокладка Coollaboratory Liquid Ultra', 'LTP-CLU-4568', 'Жидкая термопрокладка для улучшения теплоотвода'),
('Салфетка Kimberly-Clark Professional', 'WIPES-KC-PRO-5679', 'Очистка и обезжиривание'),
('Обезжириватель CRC QD Contact Cleaner', 'DEGREASER-CRC-QD-6789', 'Обезжиривание компонентов'),
('Канифоль Amtech', 'ROSIN-AMTECH-7890', 'Флюс для пайки'),
('BGA шарики 0.76mm', 'BGA-BALLS-0.76-8901', 'Используются при реболлинге BGA чипов'),
('Медная проволока 0.3mm', 'COPPER-WIRE-0.3-9012', 'Пайка и ремонт'),
('Конденсатор 47uF', 'CAP-47UF-1235', 'Стабилизация напряжения'),
('Резистор 5kOhm', 'RES-5K-2346', 'Ограничение тока'),
('GDDR6 8GB', 'GDDR6-8GB-3458', 'Видеопамять для видеокарт'),
('NVIDIA GeForce RTX 2060', 'GPU-RTX2060-4569', 'Графический процессор'),
('Intel Core i9-9900K', 'CPU-I9-9900K-5670', 'Процессор для настольных ПК'),
('Чипсет Intel H370', 'CHIPSET-H370-6780', 'Чипсет для материнских плат'),
('Сокет LGA1200', 'SOCKET-LGA1200-7893', 'Сокет для процессоров Intel'),
('Термопаста Thermal Grizzly Kryonaut', 'TP-TGK-2347', 'Термопаста для улучшения теплоотвода'),
('Термопрокладка Fujipoly 2mm', 'TPG-FUJIPOLY-2MM-3459', 'Термопрокладка для улучшения теплоотвода'),
('Жидкая термопрокладка Phobya Liquid Metal', 'LTP-PHOBYA-4569', 'Жидкая термопрокладка для улучшения теплоотвода'),
('Салфетка WypAll X60', 'WIPES-WYPALL-X60-5670', 'Очистка и обезжиривание'),
('Обезжириватель LPS KB88', 'DEGREASER-LPS-KB88-6780', 'Обезжиривание компонентов'),
('Канифоль MG Chemicals', 'ROSIN-MG-CHEM-7891', 'Флюс для пайки'),
('BGA шарики 0.5mm', 'BGA-BALLS-0.5-8902', 'Используются при реболлинге BGA чипов'),
('Медная проволока 0.4mm', 'COPPER-WIRE-0.4-9013', 'Пайка и ремонт'),
('Конденсатор 22uF', 'CAP-22UF-1236', 'Стабилизация напряжения'),
('Резистор 2kOhm', 'RES-2K-2347', 'Ограничение тока'),
('GDDR6 6GB', 'GDDR6-6GB-3459', 'Видеопамять для видеокарт'),
('NVIDIA GeForce RTX 2070', 'GPU-RTX2070-4560', 'Графический процессор'),
('Intel Core i5-10400F', 'CPU-I5-10400F-5671', 'Процессор для настольных ПК'),
('Чипсет Intel Z490', 'CHIPSET-Z490-6781', 'Чипсет для материнских плат'),
('Сокет AM3+', 'SOCKET-AM3PLUS-7894', 'Сокет для процессоров AMD'),
('Термопаста Arctic Silver 5', 'TP-AS5-2348', 'Термопаста для улучшения теплоотвода'),
('Термопрокладка Noctua 1mm', 'TPG-NOCTUA-1MM-3460', 'Термопрокладка для улучшения теплоотвода'),
('Жидкая термопрокладка Liquid Pro', 'LTP-LQPRO-4561', 'Жидкая термопрокладка для улучшения теплоотвода'),
('Салфетка Tork Advanced', 'WIPES-TORK-ADV-5671', 'Очистка и обезжиривание'),
('Обезжириватель WD-40 Specialist', 'DEGREASER-WD40-6781', 'Обезжиривание компонентов'),
('Канифоль ChipQuik', 'ROSIN-CHIPQUIK-7892', 'Флюс для пайки'),
('BGA шарики 0.4mm', 'BGA-BALLS-0.4-8903', 'Используются при реболлинге BGA чипов'),
('Медная проволока 0.6mm', 'COPPER-WIRE-0.6-9014', 'Пайка и ремонт'),
('Конденсатор 330uF', 'CAP-330UF-1237', 'Стабилизация напряжения'),
('Резистор 3kOhm', 'RES-3K-2348', 'Ограничение тока'),
('GDDR5 1GB', 'GDDR5-1GB-3461', 'Видеопамять для видеокарт'),
('NVIDIA GeForce RTX 2080', 'GPU-RTX2080-4561', 'Графический процессор'),
('Intel Core i3-10100', 'CPU-I3-10100-5672', 'Процессор для настольных ПК'),
('Чипсет Intel H310', 'CHIPSET-H310-6782', 'Чипсет для материнских плат'),
('Сокет LGA2066', 'SOCKET-LGA2066-7895', 'Сокет для процессоров Intel'),
('Термопаста Noctua NT-H2', 'TP-NTH2-2349', 'Термопаста для улучшения теплоотвода'),
('Термопрокладка Arctic 0.5mm', 'TPG-ARCTIC-0.5MM-3462', 'Термопрокладка для улучшения теплоотвода'),
('Жидкая термопрокладка Coollaboratory Liquid Pro', 'LTP-CLP-4562', 'Жидкая термопрокладка для улучшения теплоотвода'),
('Салфетка Vileda Professional', 'WIPES-VILEDA-5672', 'Очистка и обезжиривание'),
('Обезжириватель CRC 2-26', 'DEGREASER-CRC-226-6782', 'Обезжиривание компонентов'),
('Канифоль AIM Solder', 'ROSIN-AIM-7893', 'Флюс для пайки'),
('BGA шарики 0.3mm', 'BGA-BALLS-0.3-8904', 'Используются при реболлинге BGA чипов'),
('Медная проволока 0.7mm', 'COPPER-WIRE-0.7-9015', 'Пайка и ремонт'),
('Конденсатор 220uF', 'CAP-220UF-1238', 'Стабилизация напряжения'),
('Резистор 7kOhm', 'RES-7K-2349', 'Ограничение тока'),
('GDDR6 12GB', 'GDDR6-12GB-3463', 'Видеопамять для видеокарт'),
('NVIDIA GeForce RTX 3080', 'GPU-RTX3080-4563', 'Графический процессор'),
('Intel Core i9-10900K', 'CPU-I9-10900K-5673', 'Процессор для настольных ПК'),
('Чипсет Intel B460', 'CHIPSET-B460-6783', 'Чипсет для материнских плат'),
('Сокет LGA1700', 'SOCKET-LGA1700-7896', 'Сокет для процессоров Intel'),
('Термопаста Thermalright TF8', 'TP-TRTF8-2350', 'Термопаста для улучшения теплоотвода'),
('Термопрокладка Gelid Solutions 1mm', 'TPG-GELID-1MM-3464', 'Термопрокладка для улучшения теплоотвода'),
('Жидкая термопрокладка Conductonaut', 'LTP-CONDUCT-4563', 'Жидкая термопрокладка для улучшения теплоотвода');


-- Вставка данных в таблицу supplies
INSERT INTO repair_shop.supplies (suppliers_id, component_id, quantity, placing_date, departure_date) VALUES
(1, 1, 100, '2024-01-01', '2024-01-05'),
(2, 2, 200, '2024-01-02', '2024-01-06'),
(3, 3, 300, '2024-01-03', '2024-01-07'),
(4, 4, 150, '2024-01-04', '2024-01-08'),
(5, 5, 100, '2024-01-05', '2024-01-09'),
(6, 6, 80, '2024-01-06', '2024-01-10'),
(7, 7, 90, '2024-01-07', '2024-01-11'),
(8, 8, 70, '2024-01-08', '2024-01-12'),
(9, 9, 60, '2024-01-09', '2024-01-13'),
(10, 10, 50, '2024-01-10', '2024-01-14'),
(11, 11, 40, '2024-01-11', '2024-01-15'),
(12, 12, 30, '2024-01-12', '2024-01-16'),
(13, 13, 20, '2024-01-13', '2024-01-17'),
(14, 14, 10, '2024-01-14', '2024-01-18'),
(15, 15, 200, '2024-01-15', '2024-01-19'),
(16, 16, 150, '2024-01-16', '2024-01-20'),
(17, 17, 100, '2024-01-17', '2024-01-21'),
(18, 18, 80, '2024-01-18', '2024-01-22'),
(19, 19, 90, '2024-01-19', '2024-01-23'),
(20, 20, 70, '2024-01-20', '2024-01-24'),
(1, 21, 60, '2024-01-21', '2024-01-25'),
(2, 22, 50, '2024-01-22', '2024-01-26'),
(3, 23, 40, '2024-01-23', '2024-01-27'),
(4, 24, 30, '2024-01-24', '2024-01-28'),
(5, 25, 20, '2024-01-25', '2024-01-29'),
(6, 26, 10, '2024-01-26', '2024-01-30'),
(7, 27, 200, '2024-01-27', '2024-01-31'),
(8, 28, 150, '2024-01-28', '2024-02-01'),
(9, 29, 100, '2024-01-29', '2024-02-02'),
(10, 30, 80, '2024-01-30', '2024-02-03'),
(11, 31, 90, '2024-01-31', '2024-02-04'),
(12, 32, 70, '2024-02-01', '2024-02-05'),
(13, 33, 60, '2024-02-02', '2024-02-06'),
(14, 34, 50, '2024-02-03', '2024-02-07'),
(15, 35, 40, '2024-02-04', '2024-02-08'),
(16, 36, 30, '2024-02-05', '2024-02-09'),
(17, 37, 20, '2024-02-06', '2024-02-10'),
(18, 38, 10, '2024-02-07', '2024-02-11'),
(19, 39, 200, '2024-02-08', '2024-02-12'),
(20, 40, 150, '2024-02-09', '2024-02-13'),
(1, 41, 100, '2024-02-10', '2024-02-14'),
(2, 42, 80, '2024-02-11', '2024-02-15'),
(3, 43, 90, '2024-02-12', '2024-02-16'),
(4, 44, 70, '2024-02-13', '2024-02-17'),
(5, 45, 60, '2024-02-14', '2024-02-18'),
(6, 46, 50, '2024-02-15', '2024-02-19'),
(7, 47, 40, '2024-02-16', '2024-02-20'),
(8, 48, 30, '2024-02-17', '2024-02-21'),
(9, 49, 20, '2024-02-18', '2024-02-22'),
(10, 50, 10, '2024-02-19', '2024-02-23');

-- Вставка данных в таблицу equipment
INSERT INTO repair_shop.equipment (type, name, quantity, purchase_date) VALUES
('Монитор', 'Dell UltraSharp U2720Q', 5, '2023-05-01'),
('Клавиатура', 'Logitech MX Keys', 10, '2023-06-15'),
('Мышь', 'Logitech MX Master 3', 10, '2023-07-10'),
('Принтер', 'HP LaserJet Pro M404dn', 3, '2023-08-22'),
('Сканер', 'Epson Perfection V600', 2, '2023-09-05'),
('Компьютер', 'Dell OptiPlex 7080', 8, '2023-10-12'),
('Роутер', 'Asus RT-AX88U', 4, '2023-11-20'),
('Хаб', 'TP-Link TL-SG105', 6, '2023-12-01'),
('Источник питания', 'APC Back-UPS Pro 1500', 5, '2024-01-15'),
('Микроскоп', 'AmScope SM-4TZ-144A', 2, '2024-02-10'),
('Паяльник', 'Hakko FX-888D', 10, '2024-03-05'),
('Cтол', 'IKEA BEKANT', 10, '2024-04-18'),
('Кресло', 'Herman Miller Aeron', 10, '2024-05-22'),
('Коврик', 'SteelSeries QcK', 20, '2024-06-10'),
('Лабораторный блок питания', 'Korad KA3005P', 3, '2024-07-01'),
('Натфиль', 'Nicholson 6" Slim Taper', 15, '2024-08-15'),
('Отвертка', 'Wiha Precision Screwdriver Set', 25, '2024-09-05'),
('Настольная лампа', 'BenQ e-Reading Desk Lamp', 10, '2024-10-10'),
('Монитор', 'LG 27UK850-W', 7, '2024-11-01'),
('Клавиатура', 'Corsair K95 RGB', 12, '2024-12-12'),
('Мышь', 'Razer DeathAdder Elite', 12, '2024-01-25'),
('Принтер', 'Canon imageCLASS LBP6030w', 4, '2024-02-20'),
('Сканер', 'Canon CanoScan LiDE300', 3, '2024-03-30'),
('Компьютер', 'HP Z2 Mini G4', 6, '2024-04-15'),
('Роутер', 'Netgear Nighthawk AX12', 3, '2024-05-20'),
('Хаб', 'D-Link DGS-1008G', 7, '2024-06-25'),
('Источник питания', 'CyberPower CP1500PFCLCD', 4, '2024-07-30'),
('Микроскоп', 'Omano OM2300S-V7', 2, '2024-08-10'),
('Паяльник', 'Weller WE1010NA', 8, '2024-09-12'),
('Cтол', 'Uplift V2 Standing Desk', 8, '2024-10-05');

-- Вставка данных в таблицу callback_orders
INSERT INTO repair_shop.callback_orders (name, phone_number, model, defect) VALUES
('Алексей', '89012345670', 'Asus ROG Zephyrus G14', 'Не включается'),
('Мария', '89012345671', 'Dell XPS 13', 'Не заряжается'),
('Иван', '89012345672', 'HP Spectre x360', 'Перегревается'),
('Екатерина', '89012345673', 'MSI GE66 Raider', 'Нет изображения на экране'),
('Дмитрий', '89012345674', 'Gigabyte Aorus 15G', 'Проблемы с клавиатурой'),
('Анастасия', '89012345675', 'MacBook Air M1', 'Не включается'),
('Сергей', '89012345676', 'Razer Blade 15', 'Шумы из вентилятора'),
('Ольга', '89012345677', 'Lenovo Legion 5', 'Трещины на корпусе'),
('Николай', '89012345678', 'Acer Predator Helios 300', 'Проблемы с Wi-Fi'),
('Юлия', '89012345679', 'Alienware m15 R3', 'Синий экран смерти'),
('Владимир', '89012345680', 'ASRock B550 Phantom Gaming', 'Не работает USB порт'),
('Татьяна', '89012345681', 'MSI MPG Z490 Gaming Carbon', 'Не стартует BIOS'),
('Роман', '89012345682', 'Gigabyte Z490 Aorus Master', 'Проблемы с сетью'),
('Наталья', '89012345683', 'Asus TUF Gaming B550-Plus', 'Не видит оперативную память'),
('Максим', '89012345684', 'NVIDIA GeForce RTX 3080', 'Артефакты на экране');

-- Вставка данных в таблицу callback_computer_builds
INSERT INTO repair_shop.callback_computer_builds (name, phone_number, budget, usage_tasks, build_preferences) VALUES
('Алексей', '89012345670', 100000.00, 'Гейминг, Видеомонтаж', 'Компактный корпус, Хорошее охлаждение'),
('Мария', '89012345671', 70000.00, 'Работа с графикой, Учеба', 'Тихая работа, RGB подсветка'),
('Иван', '89012345672', 120000.00, 'Гейминг, Стриминг', 'Высокая производительность, Водяное охлаждение'),
('Екатерина', '89012345673', 80000.00, 'Программирование, Видеомонтаж', 'Быстрый SSD, Минимум шума'),
('Дмитрий', '89012345674', 90000.00, 'Гейминг, VR', 'Мощный графический процессор, Просторный корпус'),
('Анастасия', '89012345675', 60000.00, 'Учеба, Интернет', 'Компактный размер, Низкое энергопотребление'),
('Сергей', '89012345676', 110000.00, '3D моделирование, Гейминг', 'Высокая производительность, Дополнительные USB порты'),
('Ольга', '89012345677', 75000.00, 'Работа с офисными приложениями, Интернет', 'Тихая работа, Надежность'),
('Николай', '89012345678', 130000.00, 'Гейминг, Видеомонтаж', 'RGB подсветка, Высокая производительность'),
('Юлия', '89012345679', 70000.00, 'Учеба, Развлечения', 'Тихая работа, Небольшой корпус'),
('Владимир', '89012345680', 90000.00, 'Программирование, Гейминг', 'Многоядерный процессор, Много оперативной памяти'),
('Татьяна', '89012345681', 85000.00, 'Видеомонтаж, Графика', 'Тихая работа, Большой монитор'),
('Роман', '89012345682', 95000.00, 'Гейминг, Программирование', 'Высокая производительность, Низкий уровень шума'),
('Наталья', '89012345683', 80000.00, 'Учеба, Интернет', 'Компактный размер, Низкое энергопотребление'),
('Максим', '89012345684', 105000.00, 'Гейминг, Стриминг', 'Мощный графический процессор, Водяное охлаждение');

-- Вставка данных в таблицу roles
INSERT INTO repair_shop.roles (name) VALUES
('Инженер'),
('Приемщик'),
('Владелец'),
('Администратор баз данных');

-- Вставка данных в таблицу specializations
INSERT INTO repair_shop.specializations (name) VALUES
('Видеокарта'),
('Ноутбук'),
('Материнская плата'),
('Системный блок'),
('Сборщик системных блоков'),
('Владелец'),
('Приемщик'),
('Администратор баз данных');

-- Вставка данных в таблицу passwords
INSERT INTO repair_shop.passwords (hashed_password) VALUES
('password1'),
('password2'),
('password3'),
('password4'),
('password5'),
('password6'),
('password7'),
('password8'),
('password9'),
('password10'),
('password11'),
('password12'),
('password13'),
('password14'),
('password15'),
('password16'),
('password17'),
('password18'),
('password19'),
('password20'),
('password21');

-- Вставка данных в таблицу employees
INSERT INTO repair_shop.employees (password_id, role_id, specialization_id, fname, lname, mname, passport_number, login) VALUES
-- Инженеры по видеокартам
(1, 1, 1, 'Алексей', 'Иванов', 'Сергеевич', '1234567890', 'aivanov'),
(2, 1, 1, 'Мария', 'Петрова', 'Александровна', '0987654321', 'mpetrova'),
(3, 1, 1, 'Иван', 'Сидоров', 'Николаевич', '1122334455', 'isidorov'),
(4, 1, 1, 'Екатерина', 'Кузнецова', 'Петровна', '6677889900', 'ekuznetsova'),

-- Инженеры по ноутбукам
(5, 1, 2, 'Дмитрий', 'Смирнов', 'Иванович', '1231231230', 'dsmirnov'),
(6, 1, 2, 'Анастасия', 'Васильева', 'Дмитриевна', '3213213210', 'avasilieva'),
(7, 1, 2, 'Сергей', 'Попов', 'Алексеевич', '4564564560', 'spopov'),
(8, 1, 2, 'Ольга', 'Лебедева', 'Михайловна', '6546546540', 'olebedeva'),
(9, 1, 2, 'Николай', 'Крылов', 'Викторович', '7897897890', 'nkrylov'),

-- Инженеры по материнским платам
(10, 1, 3, 'Юлия', 'Федорова', 'Сергеевна', '1471471470', 'yfedorova'),
(11, 1, 3, 'Владимир', 'Морозов', 'Николаевич', '2582582580', 'vmorozov'),
(12, 1, 3, 'Татьяна', 'Новикова', 'Андреевна', '3693693690', 'tnovikova'),

-- Инженеры по системным блокам
(13, 1, 4, 'Роман', 'Мельников', 'Петрович', '7417417410', 'rmelnikov'),
(14, 1, 4, 'Наталья', 'Кириллова', 'Игоревна', '8528528520', 'nkirillova'),

-- Инженеры-сборщики системных блоков
(15, 1, 5, 'Максим', 'Фролов', 'Андреевич', '9639639630', 'mfrolov'),
(16, 1, 5, 'Ирина', 'Соловьева', 'Владимировна', '1591591590', 'isolovieva'),
(17, 1, 5, 'Андрей', 'Егоров', 'Борисович', '7537537530', 'aegorov'),

-- Владелец
(18, 3, 6, 'Виктор', 'Зайцев', 'Аркадьевич', '9876543210', 'vzaicev'),

-- Приемщики
(19, 2, 7, 'Елена', 'Григорьева', 'Олеговна', '1112223330', 'egrigorieva'),
(20, 2, 7, 'Павел', 'Семенов', 'Анатольевич', '4445556660', 'psemenov'),

-- Администратор баз данных
(21, 4, 8, 'Владислав', 'Мартынов', 'Ильич', '7778889990', 'vmartynov');

-- Вставка данных в таблицу clients
INSERT INTO repair_shop.clients (name, phone_number) VALUES
('Алексей', '89012345670'),
('Мария', '89012345671'),
('Иван', '89012345672'),
('Екатерина', '89012345673'),
('Дмитрий', '89012345674'),
('Анастасия', '89012345675'),
('Сергей', '89012345676'),
('Ольга', '89012345677'),
('Николай', '89012345678'),
('Юлия', '89012345679'),
('Владимир', '89012345680'),
('Татьяна', '89012345681'),
('Роман', '89012345682'),
('Наталья', '89012345683'),
('Максим', '89012345684'),
('Елена', '89012345685'),
('Павел', '89012345686'),
('Виктор', '89012345687'),
('Ирина', '89012345688'),
('Андрей', '89012345689'),
('Егор', '89012345690'),
('Анна', '89012345691'),
('Михаил', '89012345692'),
('Лариса', '89012345693'),
('Георгий', '89012345694'),
('Ксения', '89012345695'),
('Федор', '89012345696'),
('Дарья', '89012345697'),
('Александр', '89012345698'),
('Полина', '89012345699'),
('Валерий', '89012345700'),
('Светлана', '89012345701'),
('Юрий', '89012345702'),
('Вера', '89012345703'),
('Артур', '89012345704'),
('Алёна', '89012345705'),
('Леонид', '89012345706'),
('Людмила', '89012345707'),
('Денис', '89012345708'),
('Евгения', '89012345709'),
('Григорий', '89012345710'),
('Алина', '89012345711'),
('Вадим', '89012345712'),
('Кирилл', '89012345713'),
('Ариана', '89012345714'),
('Степан', '89012345715'),
('Милена', '89012345716'),
('Никита', '89012345717'),
('Зоя', '89012345718'),
('Тимур', '89012345719'),
('Маргарита', '89012345720'),
('Василий', '89012345721'),
('София', '89012345722'),
('Константин', '89012345723'),
('Вероника', '89012345724'),
('Борис', '89012345725'),
('Аделина', '89012345726'),
('Арсений', '89012345727'),
('Майя', '89012345728'),
('Петр', '89012345729'),
('Юлия', '89012345730'),
('Олег', '89012345731'),
('Диана', '89012345732'),
('Геннадий', '89012345733'),
('Алла', '89012345734'),
('Давид', '89012345735'),
('Тамара', '89012345736'),
('Артем', '89012345737'),
('Регина', '89012345738'),
('Матвей', '89012345739'),
('Кристина', '89012345740'),
('Глеб', '89012345741'),
('Елизавета', '89012345742'),
('Игорь', '89012345743'),
('Екатерина', '89012345744'),
('Вячеслав', '89012345745');

-- Вставка данных в таблицу devices
INSERT INTO repair_shop.devices (client_id, type, model, serial_number) VALUES
(1, 'Ноутбук', 'Dell XPS 13 9310', 'DXPS9310-123456'),
(2, 'Ноутбук', 'Apple MacBook Pro 16"', 'MBP16-987654'),
(3, 'Ноутбук', 'HP Spectre x360 14', 'HSX36014-456789'),
(4, 'Ноутбук', 'Lenovo ThinkPad X1 Carbon Gen 9', 'LTX1C9-123789'),
(5, 'Ноутбук', 'Asus ROG Zephyrus G14', 'ARG14-987321'),
(6, 'Ноутбук', 'Microsoft Surface Laptop 4', 'MSL4-654321'),
(7, 'Ноутбук', 'Razer Blade 15', 'RB15-456123'),
(8, 'Ноутбук', 'Acer Predator Helios 300', 'APH300-321654'),
(9, 'Ноутбук', 'MSI GS66 Stealth', 'MSGS66-789456'),
(10, 'Ноутбук', 'Gigabyte Aero 15', 'GAERO15-987654'),
(11, 'Материнская плата', 'ASUS ROG Strix Z590-E', 'AROGZ590E-654789'),
(12, 'Материнская плата', 'MSI MPG Z490 Gaming Edge', 'MSIZ490GE-123654'),
(13, 'Материнская плата', 'Gigabyte Z590 Aorus Master', 'GZ590AM-456987'),
(14, 'Материнская плата', 'ASRock B550 Phantom Gaming', 'AB550PG-789321'),
(15, 'Материнская плата', 'Intel NUC 9 Extreme', 'INUC9E-321987'),
(16, 'Материнская плата', 'EVGA Z490 Dark', 'EVGAZ490D-123456'),
(17, 'Материнская плата', 'ASUS TUF Gaming B550-Plus', 'ATG550P-654123'),
(18, 'Материнская плата', 'MSI MEG Z590 Godlike', 'MSIZ590G-789654'),
(19, 'Материнская плата', 'Gigabyte B550 Vision D', 'GB550VD-987123'),
(20, 'Материнская плата', 'ASRock X570 Taichi', 'AX570T-456321'),
(21, 'Видеокарта', 'NVIDIA GeForce RTX 3080', 'NRTX3080-123789'),
(22, 'Видеокарта', 'AMD Radeon RX 6800 XT', 'ARX6800XT-654987'),
(23, 'Видеокарта', 'NVIDIA GeForce RTX 3070', 'NRTX3070-321654'),
(24, 'Видеокарта', 'AMD Radeon RX 6700 XT', 'ARX6700XT-789123'),
(25, 'Видеокарта', 'NVIDIA GeForce RTX 3060 Ti', 'NRTX3060TI-456987'),
(26, 'Видеокарта', 'AMD Radeon RX 6600 XT', 'ARX6600XT-987321'),
(27, 'Видеокарта', 'NVIDIA GeForce RTX 3050', 'NRTX3050-654123'),
(28, 'Видеокарта', 'AMD Radeon RX 6500 XT', 'ARX6500XT-321987'),
(29, 'Видеокарта', 'NVIDIA GeForce GTX 1660 Super', 'NGTX1660S-789654'),
(30, 'Видеокарта', 'AMD Radeon RX 5700 XT', 'ARX5700XT-123456'),
(31, 'Ноутбук', 'Dell Inspiron 15', 'DINSP15-456123'),
(32, 'Ноутбук', 'HP Pavilion x360', 'HPX360-789321'),
(33, 'Ноутбук', 'Asus ZenBook 14', 'AZB14-123654'),
(34, 'Ноутбук', 'Lenovo Yoga 9i', 'LY9I-456987'),
(35, 'Ноутбук', 'Microsoft Surface Book 3', 'MSB3-987456'),
(36, 'Ноутбук', 'Razer Blade Stealth 13', 'RBS13-321654'),
(37, 'Ноутбук', 'Acer Swift 3', 'AS3-654789'),
(38, 'Ноутбук', 'MSI Prestige 14', 'MSP14-987321'),
(39, 'Ноутбук', 'Gigabyte G5 KC', 'GG5KC-123987'),
(40, 'Ноутбук', 'Apple MacBook Air M1', 'MBAIR-M1-456321'),
(41, 'Материнская плата', 'ASUS Prime Z490-A', 'APZ490A-654123'),
(42, 'Материнская плата', 'MSI B450 TOMAHAWK MAX', 'MSB450TM-789654'),
(43, 'Материнская плата', 'Gigabyte Z490 AORUS ELITE', 'GZ490AE-123321'),
(44, 'Материнская плата', 'ASRock B450 Steel Legend', 'AB450SL-456654'),
(45, 'Материнская плата', 'EVGA Z390 FTW', 'EVGAZ390F-789987'),
(46, 'Материнская плата', 'ASUS ROG Crosshair VIII Hero', 'ARC8H-987654'),
(47, 'Материнская плата', 'MSI X570-A PRO', 'MSX570AP-321123'),
(48, 'Материнская плата', 'Gigabyte X570 Aorus Elite', 'GX570AE-654456'),
(49, 'Материнская плата', 'ASRock X299 Taichi', 'AX299T-987789'),
(50, 'Материнская плата', 'ASUS TUF Z390-PLUS Gaming', 'ATZ390P-123987'),
(51, 'Видеокарта', 'NVIDIA GeForce GTX 1650', 'NGTX1650-456321'),
(52, 'Видеокарта', 'AMD Radeon RX 5600 XT', 'ARX5600XT-789456'),
(53, 'Видеокарта', 'NVIDIA GeForce GTX 1660', 'NGTX1660-321789'),
(54, 'Видеокарта', 'AMD Radeon RX 5500 XT', 'ARX5500XT-654321'),
(55, 'Видеокарта', 'NVIDIA GeForce RTX 2080 Ti', 'NRTX2080TI-987456'),
(56, 'Видеокарта', 'AMD Radeon VII', 'ARVII-123654'),
(57, 'Видеокарта', 'NVIDIA GeForce RTX 2070', 'NRTX2070-456789'),
(58, 'Видеокарта', 'AMD Radeon RX 590', 'ARX590-789321'),
(59, 'Видеокарта', 'NVIDIA GeForce GTX 1080 Ti', 'NGTX1080TI-321987'),
(60, 'Видеокарта', 'AMD Radeon RX 580', 'ARX580-654987'),
(61, 'Ноутбук', 'Dell G5 15', 'DG515-987123'),
(62, 'Ноутбук', 'HP Envy 13', 'HE13-123456'),
(63, 'Ноутбук', 'Asus VivoBook S15', 'AVS15-654321'),
(64, 'Ноутбук', 'Lenovo IdeaPad Flex 5', 'LIF5-987654'),
(65, 'Ноутбук', 'Microsoft Surface Go 2', 'MSG2-321456'),
(66, 'Ноутбук', 'Razer Book 13', 'RB13-456789'),
(67, 'Ноутбук', 'Acer Aspire 5', 'AA5-987321'),
(68, 'Ноутбук', 'MSI Modern 14', 'MSM14-123789'),
(69, 'Ноутбук', 'Gigabyte G7', 'GG7-654123'),
(70, 'Ноутбук', 'Apple MacBook Pro 13"', 'MBP13-987654'),
(71, 'Материнская плата', 'ASUS Prime B550-Plus', 'APB550P-321987'),
(72, 'Материнская плата', 'MSI B550M PRO-VDH', 'MSB550MVDH-654321'),
(73, 'Материнская плата', 'Gigabyte Z490M Gaming X', 'GZ490MGX-987123'),
(74, 'Материнская плата', 'ASRock B550M Pro4', 'AB550MP4-123456'),
(75, 'Материнская плата', 'EVGA Z370 Classified K', 'EVGAZ370CK-456789'),
(76, 'Материнская плата', 'ASUS ROG Strix X570-E', 'ARX570E-789321');

-- Вставка данных в таблицу orders
INSERT INTO repair_shop.orders (order_id, device_id, client_id, engineer_id, defect, status, cost, creation_date) VALUES
(21, 1, 1, 1, 'Не включается', 'Создан', 3500.00, '2024-01-10'),
(22, 2, 2, 2, 'Не заряжается', 'В работе', 4000.00, '2024-01-11'),
(23, 3, 3, 3, 'Перегревается', 'Готов к выдаче', 4500.00, '2024-01-12'),
(24, 4, 4, 4, 'Нет изображения на экране', 'Создан', 5000.00, '2024-01-13'),
(25, 5, 5, 5, 'Проблемы с клавиатурой', 'В работе', 3000.00, '2024-01-14'),
(26, 6, 6, 6, 'Не включается', 'Готов к выдаче', 3500.00, '2024-01-15'),
(27, 7, 7, 7, 'Шумы из вентилятора', 'Создан', 2500.00, '2024-01-16'),
(28, 8, 8, 8, 'Трещины на корпусе', 'В работе', 2000.00, '2024-01-17'),
(29, 9, 9, 9, 'Проблемы с Wi-Fi', 'Готов к выдаче', 1500.00, '2024-01-18'),
(30, 10, 10, 10, 'Синий экран смерти', 'Создан', 4000.00, '2024-01-19'),
(31, 11, 11, 11, 'Не работает USB порт', 'В работе', 4500.00, '2024-01-20'),
(32, 12, 12, 12, 'Не стартует BIOS', 'Готов к выдаче', 5000.00, '2024-01-21'),
(33, 13, 13, 13, 'Проблемы с сетью', 'Создан', 3500.00, '2024-01-22'),
(34, 14, 14, 14, 'Не видит оперативную память', 'В работе', 3000.00, '2024-01-23'),
(35, 15, 15, 15, 'Артефакты на экране', 'Готов к выдаче', 4000.00, '2024-01-24'),
(36, 16, 16, 1, 'Не включается', 'Создан', 3500.00, '2024-01-25'),
(37, 17, 17, 2, 'Не заряжается', 'В работе', 4000.00, '2024-01-26'),
(38, 18, 18, 3, 'Перегревается', 'Готов к выдаче', 4500.00, '2024-01-27'),
(39, 19, 19, 4, 'Нет изображения на экране', 'Создан', 5000.00, '2024-01-28'),
(40, 20, 20, 5, 'Проблемы с клавиатурой', 'В работе', 3000.00, '2024-01-29');

-- Вставка данных в таблицу computer_builds
INSERT INTO repair_shop.computer_builds (build_id, client_id, engineer_id, components, components_cost, status, creation_date) VALUES
(16, 1, 15,
'Процессор: Intel Core i7-13700K, Материнская плата: ASUS ROG Strix Z790-E, Оперативная память: G.Skill Trident Z5, DDR5, 6000MHz, Охлаждение процессора: Водяное, Corsair Hydro Series H150i, Накопители: SSD, Samsung 980 Pro 1TB, Блок питания: Corsair RM850x, Корпус: NZXT H710',
150000.00, 'Создан', '2024-01-10'),
(17, 2, 16,
'Процессор: AMD Ryzen 9 7900X, Материнская плата: MSI MPG B650, Оперативная память: Corsair Vengeance, DDR5, 5600MHz, Охлаждение процессора: Воздушное, Noctua NH-D15, Накопители: SSD, WD Black SN850 1TB, Блок питания: Seasonic Focus GX-850, Корпус: Fractal Design Meshify C',
145000.00, 'В работе', '2024-01-11'),
(18, 3, 17,
'Процессор: Intel Core i9-13900K, Материнская плата: Gigabyte Z790 Aorus Master, Оперативная память: Kingston Fury, DDR5, 6000MHz, Охлаждение процессора: Водяное, NZXT Kraken Z73, Накопители: SSD, Samsung 970 Evo Plus 2TB, Блок питания: EVGA SuperNOVA 1000 G+, Корпус: Lian Li PC-O11 Dynamic',
200000.00, 'Готов к выдаче', '2024-01-12'),
(19, 4, 15,
'Процессор: AMD Ryzen 7 7700X, Материнская плата: ASUS TUF Gaming B650-PLUS, Оперативная память: G.Skill Ripjaws V, DDR5, 5200MHz, Охлаждение процессора: Воздушное, Cooler Master Hyper 212, Накопители: SSD, Crucial P5 Plus 1TB, Блок питания: Be Quiet! Straight Power 11 750W, Корпус: Corsair 4000D Airflow',
130000.00, 'Создан', '2024-01-13'),
(20, 5, 16,
'Процессор: Intel Core i5-13600K, Материнская плата: MSI MAG Z690 Tomahawk, Оперативная память: Corsair Vengeance, DDR5, 6000MHz, Охлаждение процессора: Воздушное, be quiet! Dark Rock Pro 4, Накопители: SSD, Samsung 980 Pro 500GB, Блок питания: Cooler Master MWE Gold 750, Корпус: Phanteks Eclipse P400A',
125000.00, 'В работе', '2024-01-14'),
(21, 6, 17,
'Процессор: AMD Ryzen 9 7950X, Материнская плата: Gigabyte X670 Aorus Master, Оперативная память: Corsair Dominator Platinum, DDR5, 6000MHz, Охлаждение процессора: Водяное, EK-AIO 360 D-RGB, Накопители: SSD, Kingston KC3000 2TB, Блок питания: Corsair HX1000, Корпус: Cooler Master MasterCase H500',
210000.00, 'Готов к выдаче', '2024-01-15'),
(22, 7, 15,
'Процессор: Intel Core i7-12700K, Материнская плата: ASUS Prime Z690-P, Оперативная память: G.Skill Trident Z5, DDR5, 6000MHz, Охлаждение процессора: Воздушное, Noctua NH-U12S, Накопители: SSD, WD Black SN850 1TB, Блок питания: EVGA SuperNOVA 850 G5, Корпус: NZXT H510',
140000.00, 'Создан', '2024-01-16'),
(23, 8, 16,
'Процессор: AMD Ryzen 7 7700, Материнская плата: MSI MAG B650 TOMAHAWK, Оперативная память: Corsair Vengeance, DDR5, 5600MHz, Охлаждение процессора: Воздушное, Scythe Fuma 2, Накопители: SSD, Samsung 980 1TB, Блок питания: Seasonic Focus PX-750, Корпус: Fractal Design Define 7',
135000.00, 'В работе', '2024-01-17'),
(24, 9, 17,
'Процессор: Intel Core i9-12900K, Материнская плата: ASRock Z690 Taichi, Оперативная память: Kingston Fury, DDR5, 6000MHz, Охлаждение процессора: Водяное, Corsair iCUE H150i Elite, Накопители: SSD, WD Black SN750 2TB, Блок питания: Corsair RM1000x, Корпус: Phanteks Evolv X',
195000.00, 'Готов к выдаче', '2024-01-18'),
(25, 10, 15,
'Процессор: AMD Ryzen 9 5900X, Материнская плата: ASUS ROG Crosshair VIII Hero, Оперативная память: G.Skill Trident Z Neo, DDR4, 3600MHz, Охлаждение процессора: Воздушное, Noctua NH-D15, Накопители: SSD, Samsung 970 Evo Plus 1TB, Блок питания: EVGA SuperNOVA 850 G3, Корпус: NZXT H700i',
175000.00, 'Создан', '2024-01-19');

-- Вставка данных в таблицу archived_orders
INSERT INTO repair_shop.archived_orders (id, device_id, client_id, engineer_id, status, cost, creation_date, completion_date) VALUES
(1, 31, 21, 6, 'Завершен', 3500.00, '2023-01-10', '2023-01-20'),
(2, 32, 22, 7, 'Завершен', 4000.00, '2023-01-11', '2023-01-21'),
(3, 33, 23, 8, 'Завершен', 4500.00, '2023-01-12', '2023-01-22'),
(4, 34, 24, 9, 'Завершен', 5000.00, '2023-01-13', '2023-01-23'),
(5, 35, 25, 10, 'Завершен', 3000.00, '2023-01-14', '2023-01-24'),
(6, 36, 26, 11, 'Завершен', 3500.00, '2023-01-15', '2023-01-25'),
(7, 37, 27, 12, 'Завершен', 2500.00, '2023-01-16', '2023-01-26'),
(8, 38, 28, 13, 'Завершен', 2000.00, '2023-01-17', '2023-01-27'),
(9, 39, 29, 14, 'Завершен', 1500.00, '2023-01-18', '2023-01-28'),
(10, 40, 30, 1, 'Завершен', 4000.00, '2023-01-19', '2023-01-29'),
(11, 41, 31, 2, 'Завершен', 4500.00, '2023-01-20', '2023-01-30'),
(12, 42, 32, 3, 'Завершен', 5000.00, '2023-01-21', '2023-01-31'),
(13, 43, 33, 4, 'Завершен', 3500.00, '2023-01-22', '2023-02-01'),
(14, 44, 34, 5, 'Завершен', 3000.00, '2023-01-23', '2023-02-02'),
(15, 45, 35, 6, 'Завершен', 4000.00, '2023-01-24', '2023-02-03'),
(16, 46, 36, 7, 'Завершен', 3500.00, '2023-01-25', '2023-02-04'),
(17, 47, 37, 8, 'Завершен', 4000.00, '2023-01-26', '2023-02-05'),
(18, 48, 38, 9, 'Завершен', 4500.00, '2023-01-27', '2023-02-06'),
(19, 49, 39, 10, 'Завершен', 5000.00, '2023-01-28', '2023-02-07'),
(20, 50, 40, 11, 'Завершен', 3000.00, '2023-01-29', '2023-02-08');

-- Вставка данных в таблицу archived_computer_builds
INSERT INTO repair_shop.archived_computer_builds (id, client_id, engineer_id, components, components_cost, service_fee, status, creation_date, completion_date) VALUES
(1, 21, 15,
'Процессор: Intel Core i7-11700K, Материнская плата: MSI Z590 Pro, Оперативная память: Corsair Vengeance LPX, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Cooler Master Hyper 212, Накопители: SSD, Samsung 970 Evo 500GB, Блок питания: Corsair CX650, Корпус: NZXT H510',
100000.00, 8000.00, 'Завершен', '2023-01-10', '2023-01-20'),
(2, 22, 16,
'Процессор: AMD Ryzen 5 5600X, Материнская плата: ASUS TUF Gaming B550-PLUS, Оперативная память: G.Skill Ripjaws V, DDR4, 3600MHz, Охлаждение процессора: Воздушное, Noctua NH-U12S, Накопители: SSD, WD Blue SN550 1TB, Блок питания: Seasonic S12III 650, Корпус: Cooler Master MasterBox Q300L',
90000.00, 7200.00, 'Завершен', '2023-01-11', '2023-01-21'),
(3, 23, 17,
'Процессор: Intel Core i9-11900K, Материнская плата: ASUS ROG Maximus XIII Hero, Оперативная память: Corsair Dominator Platinum, DDR4, 3600MHz, Охлаждение процессора: Водяное, Corsair H100i, Накопители: SSD, Samsung 980 Pro 1TB, Блок питания: EVGA SuperNOVA 850 G5, Корпус: Fractal Design Meshify C',
150000.00, 12000.00, 'Завершен', '2023-01-12', '2023-01-22'),
(4, 24, 15,
'Процессор: AMD Ryzen 7 5800X, Материнская плата: MSI MPG B550 Gaming Edge, Оперативная память: Crucial Ballistix, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Be Quiet! Dark Rock 4, Накопители: SSD, Crucial P5 1TB, Блок питания: Corsair RM750, Корпус: Lian Li Lancool II',
120000.00, 9600.00, 'Завершен', '2023-01-13', '2023-01-23'),
(5, 25, 16,
'Процессор: Intel Core i5-11600K, Материнская плата: Gigabyte Z590 Aorus Elite, Оперативная память: Kingston HyperX Fury, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Arctic Freezer 34, Накопители: SSD, Samsung 970 Evo Plus 500GB, Блок питания: Thermaltake Smart BX1 650W, Корпус: NZXT H510 Elite',
95000.00, 7600.00, 'Завершен', '2023-01-14', '2023-01-24'),
(6, 26, 17,
'Процессор: AMD Ryzen 9 5900X, Материнская плата: ASUS ROG Strix X570-E, Оперативная память: Corsair Vengeance RGB Pro, DDR4, 3600MHz, Охлаждение процессора: Воздушное, Noctua NH-D15, Накопители: SSD, WD Black SN750 1TB, Блок питания: EVGA SuperNOVA 750 G3, Корпус: Phanteks Eclipse P500A',
160000.00, 12800.00, 'Завершен', '2023-01-15', '2023-01-25'),
(7, 27, 15,
'Процессор: Intel Core i7-10700K, Материнская плата: MSI MPG Z490 Gaming Edge, Оперативная память: G.Skill Ripjaws V, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Be Quiet! Pure Rock 2, Накопители: SSD, Samsung 970 Evo 1TB, Блок питания: Seasonic Focus GX-650, Корпус: NZXT H210',
110000.00, 8800.00, 'Завершен', '2023-01-16', '2023-01-26'),
(8, 28, 16,
'Процессор: AMD Ryzen 5 5600G, Материнская плата: ASUS TUF Gaming B550M-PLUS, Оперативная память: Corsair Vengeance LPX, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Cooler Master Hyper 212, Накопители: SSD, Kingston A2000 1TB, Блок питания: EVGA 600 W1, Корпус: Fractal Design Define Mini C',
85000.00, 6800.00, 'Завершен', '2023-01-17', '2023-01-27'),
(9, 29, 17,
'Процессор: Intel Core i9-10900K, Материнская плата: Gigabyte Z490 Aorus Ultra, Оперативная память: Crucial Ballistix Max, DDR4, 4400MHz, Охлаждение процессора: Водяное, NZXT Kraken X73, Накопители: SSD, WD Black SN850 2TB, Блок питания: Corsair RM850x, Корпус: Lian Li PC-O11 Dynamic',
180000.00, 14400.00, 'Завершен', '2023-01-18', '2023-01-28'),
(10, 30, 15,
'Процессор: AMD Ryzen 7 3700X, Материнская плата: ASUS Prime X570-Pro, Оперативная память: Kingston HyperX Predator, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Be Quiet! Dark Rock Pro 4, Накопители: SSD, Samsung 970 Evo Plus 1TB, Блок питания: Seasonic Focus PX-750, Корпус: Cooler Master MasterCase H500',
130000.00, 10400.00, 'Завершен', '2023-01-19', '2023-01-29'),
(11, 31, 16,
'Процессор: Intel Core i5-10600K, Материнская плата: MSI MAG Z490 Tomahawk, Оперативная память: Corsair Vengeance LPX, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Noctua NH-U12S, Накопители: SSD, Crucial P5 1TB, Блок питания: Corsair CX650M, Корпус: Phanteks Eclipse P300A',
90000.00, 7200.00, 'Завершен', '2023-01-20', '2023-01-30'),
(12, 32, 17,
'Процессор: AMD Ryzen 9 3900X, Материнская плата: ASUS ROG Crosshair VIII Hero, Оперативная память: G.Skill Trident Z Neo, DDR4, 3600MHz, Охлаждение процессора: Воздушное, Be Quiet! Dark Rock 4, Накопители: SSD, Samsung 970 Evo 2TB, Блок питания: EVGA SuperNOVA 850 G5, Корпус: NZXT H510i',
140000.00, 11200.00, 'Завершен', '2023-01-21', '2023-01-31'),
(13, 33, 15,
'Процессор: Intel Core i7-9700K, Материнская плата: Gigabyte Z390 Aorus Master, Оперативная память: Corsair Vengeance RGB Pro, DDR4, 3600MHz, Охлаждение процессора: Водяное, Corsair H100i RGB Platinum, Накопители: SSD, WD Blue SN550 1TB, Блок питания: Seasonic Focus GX-750, Корпус: Fractal Design Meshify S2',
125000.00, 10000.00, 'Завершен', '2023-01-22', '2023-02-01'),
(14, 34, 16,
'Процессор: AMD Ryzen 7 2700X, Материнская плата: MSI X470 Gaming Pro Carbon, Оперативная память: G.Skill Ripjaws V, DDR4, 3200MHz, Охлаждение процессора: Воздушное, Cooler Master Hyper 212, Накопители: SSD, Samsung 970 Evo Plus 500GB, Блок питания: Corsair RM650, Корпус: NZXT H500',
95000.00, 7600.00, 'Завершен', '2023-01-23', '2023-02-02'),
(15, 35, 17,
'Процессор: Intel Core i5-9600K, Материнская плата: ASUS Prime Z390-A, Оперативная память: Corsair Vengeance LPX, DDR4, 3000MHz, Охлаждение процессора: Воздушное, Noctua NH-U12S, Накопители: SSD, Crucial MX500 1TB, Блок питания: EVGA 600 W1, Корпус: Fractal Design Define R6',
85000.00, 6800.00, 'Завершен', '2023-01-24', '2023-02-03');


-- Наиболее результативный сотрудник
WITH monthly_orders AS (
    SELECT engineer_id, DATE_TRUNC('month', completion_date) AS month, SUM(cost) AS total_cost
    FROM repair_shop.archived_orders
    GROUP BY engineer_id, DATE_TRUNC('month', completion_date)
),
monthly_builds AS (
    SELECT engineer_id, DATE_TRUNC('month', completion_date) AS month, SUM(service_fee) AS total_cost
    FROM repair_shop.archived_computer_builds
    GROUP BY engineer_id, DATE_TRUNC('month', completion_date)
),
combined_totals AS (
    SELECT engineer_id, month, SUM(total_cost) AS total_revenue
    FROM (
        SELECT * FROM monthly_orders
        UNION ALL
        SELECT * FROM monthly_builds
    ) AS combined
    GROUP BY engineer_id, month
)
SELECT
    TO_CHAR(ct.month, 'YYYY-MM') AS "Месяц",
    e.lname AS "Фамилия",
    e.fname AS "Имя",
    e.mname AS "Отчество",
    s.name AS "Специализация",
    ct.total_revenue AS "Выручка"
FROM combined_totals ct
JOIN repair_shop.employees e ON e.employee_id = ct.engineer_id
JOIN repair_shop.specializations s ON e.specialization_id = s.specialization_id
ORDER BY ct.month, ct.total_revenue DESC;

SELECT
    d.type AS "Тип устройства",
    COUNT(*) AS "Количество ремонтов"
FROM repair_shop.devices d
JOIN repair_shop.orders o ON d.device_id = o.device_id
GROUP BY d.type
ORDER BY COUNT(*) DESC;

WITH monthly_repair_orders AS (
    SELECT
        DATE_TRUNC('month', ao.completion_date) AS month,
        SUM(ao.cost) AS total_repair_cost
    FROM
        repair_shop.archived_orders ao
    GROUP BY
        DATE_TRUNC('month', ao.completion_date)
),
monthly_computer_builds AS (
    SELECT
        DATE_TRUNC('month', acb.completion_date) AS month,
        SUM(acb.service_fee) AS total_build_cost
    FROM
        repair_shop.archived_computer_builds acb
    GROUP BY
        DATE_TRUNC('month', acb.completion_date)
),
combined_financials AS (
    SELECT
        COALESCE(mro.month, mcb.month) AS month,
        COALESCE(mro.total_repair_cost, 0) AS total_repair_cost,
        COALESCE(mcb.total_build_cost, 0) AS total_build_cost,
        COALESCE(mro.total_repair_cost, 0) + COALESCE(mcb.total_build_cost, 0) AS total_revenue
    FROM
        monthly_repair_orders mro
    FULL OUTER JOIN
        monthly_computer_builds mcb
    ON
        mro.month = mcb.month
)
SELECT
    TO_CHAR(month, 'YYYY-MM') AS "Месяц",
    total_repair_cost AS "Общая стоимость ремонтов",
    total_build_cost AS "Общая стоимость сборок",
    total_revenue AS "Общая выручка"
FROM
    combined_financials
ORDER BY
    month;