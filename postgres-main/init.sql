drop database if exists repair_shop;

create database repair_shop;

\c repair_shop;

create schema repair_shop;

set search_path = 'repair_shop';


drop table if exists Repairs;
drop table if exists Devices;
drop table if exists Clients;
drop table if exists Technicians;

-- Создание таблицы для клиентов
CREATE TABLE Clients (
    client_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- Создание таблицы для устройств
CREATE TABLE Devices (
    device_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES Clients(client_id),
    device_type VARCHAR(50) NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    serial_number VARCHAR(50),
    date_received DATE NOT NULL,
    date_returned DATE,
    repair_description TEXT,
    status VARCHAR(20) DEFAULT 'Received' CHECK (status IN ('Received', 'In Progress', 'Completed', 'Cancelled'))
);

create table Technicians (
    technician_id serial primary key,
    lname varchar(20),
    fname varchar(20),
    mname varchar(20),
    position varchar(50)
);

-- Создание таблицы для записей о ремонте
CREATE TABLE Repairs (
    repair_id SERIAL PRIMARY KEY,
    device_id INT REFERENCES Devices(device_id),
    technician_id int references Technicians(technician_id),
    repair_date DATE NOT NULL,
    repair_description TEXT,
    parts_replaced TEXT,
    repair_cost NUMERIC(10,2),
    notes TEXT
);

INSERT INTO Clients (name, email, phone) VALUES
('John Smith', 'john@example.com', '123-456-7890'),
('Alice Johnson', 'alice@example.com', '456-789-0123'),
('Bob Williams', 'bob@example.com', '789-012-3456'),
('Emily Davis', 'emily@example.com', '012-345-6789'),
('Michael Brown', 'michael@example.com', '234-567-8901'),
('Emma Miller', 'emma@example.com', '567-890-1234'),
('Oliver Wilson', 'oliver@example.com', '890-123-4567'),
('Sophia Moore', 'sophia@example.com', '123-456-7890'),
('William Taylor', 'william@example.com', '456-789-0123'),
('Ava Anderson', 'ava@example.com', '789-012-3456');

INSERT INTO Devices (client_id, device_type, brand, model, serial_number, date_received, date_returned, repair_description, status) VALUES
(1, 'Laptop', 'Dell', 'Latitude', 'DL123456', '2024-03-01', '2024-03-15', 'Screen replacement', 'Completed'),
(2, 'Smartphone', 'Apple', 'iPhone 12', 'AP987654', '2024-02-15', '2024-02-25', 'Battery replacement', 'Completed'),
(3, 'Tablet', 'Samsung', 'Galaxy Tab S7', 'SG654321', '2024-01-10', NULL, 'Software update', 'In Progress'),
(4, 'Desktop', 'HP', 'Pavilion', 'HP246810', '2024-02-01', NULL, 'RAM upgrade', 'In Progress'),
(5, 'Smartwatch', 'Fitbit', 'Versa 3', 'FB13579', '2024-03-20', '2024-03-25', 'Display issue', 'Completed'),
(6, 'Printer', 'Epson', 'WorkForce Pro', 'EP97531', '2024-02-10', '2024-02-20', 'Paper jam', 'Completed'),
(7, 'Smartphone', 'Samsung', 'Galaxy S21', 'SG753159', '2024-03-05', NULL, 'Screen repair', 'In Progress'),
(8, 'Tablet', 'Apple', 'iPad Air', 'AP246810', '2024-01-20', NULL, 'Battery replacement', 'In Progress'),
(9, 'Laptop', 'Lenovo', 'ThinkPad', 'LN35791', '2024-03-10', NULL, 'Keyboard replacement', 'In Progress'),
(10, 'Desktop', 'Dell', 'Inspiron', 'DL57913', '2024-02-05', NULL, 'Hard drive replacement', 'Received');

INSERT INTO Technicians (lname, fname, mname, position) VALUES
('Johnson', 'James', 'A', 'Senior Technician'),
('Williams', 'Sarah', 'B', 'Junior Technician'),
('Brown', 'Michael', 'C', 'Technician'),
('Davis', 'Emily', 'D', 'Trainee Technician'),
('Miller', 'Emma', 'E', 'Senior Technician'),
('Wilson', 'Oliver', 'F', 'Technician'),
('Moore', 'Sophia', 'G', 'Junior Technician'),
('Taylor', 'William', 'H', 'Senior Technician'),
('Anderson', 'Ava', 'I', 'Technician'),
('Smith', 'John', 'J', 'Junior Technician');

INSERT INTO Repairs (device_id, technician_id, repair_date, repair_description, parts_replaced, repair_cost, notes) VALUES
(1, 1, '2024-03-15', 'Replaced screen and keyboard', 'Screen, keyboard', 150.00, 'Customer satisfied'),
(2, 2, '2024-02-25', 'Installed new battery', 'Battery', 50.00, 'Device tested OK'),
(3, 3, '2024-01-15', 'Updated software to latest version', 'None', 0.00, 'Device working fine'),
(4, 4, '2024-02-10', 'Added 8GB RAM', 'RAM module', 80.00, 'Customer happy with performance'),
(5, 5, '2024-03-25', 'Replaced display unit', 'Display unit', 100.00, 'Tested all features'),
(6, 6, '2024-02-20', 'Cleared paper jam and updated drivers', 'None', 0.00, 'Tested print quality'),
(7, 7, '2024-03-10', 'Replaced damaged screen', 'Screen', 90.00, 'Awaiting customer approval'),
(8, 8, '2024-01-30', 'Installed new battery', 'Battery', 60.00, 'Waiting for parts'),
(9, 9, '2024-03-20', 'Replaced faulty keyboard', 'Keyboard', 70.00, 'Device returned to customer'),
(10, 10, '2024-02-10', 'Installed new hard drive', 'Hard drive', 120.00, 'Customer informed');
