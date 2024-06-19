from flask import current_app
from sqlalchemy import ForeignKey, CheckConstraint, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property
from . import db

class Supplier(db.Model):
    __tablename__ = 'suppliers'
    __table_args__ = (
        CheckConstraint(
            "type IN ('Разъемы', 'Конденсаторы', 'Резисторы', 'Видеопамять', 'Чипы GPU', 'Чипы CPU', 'Чипсеты', 'Сокеты', 'Донорские компоненты', 'Термопасты', 'Термопаста с фазовым переходом', 'Термопрокладки', 'Жидкие термопрокладки', 'Салфетки', 'Обезжириватель', 'Канифоль', 'BGA шарики', 'Медная проволока')", 
            name='supplier_type_check'
        ),
        {'schema': 'repair_shop'}
    )
    supplier_id = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.String(30), nullable=False)
    name = db.Column(db.Text, nullable=False)
    address = db.Column(db.Text, nullable=False)
    contact_info = db.Column(db.Text, nullable=False)

class Component(db.Model):
    __tablename__ = 'components'
    __table_args__ = {'schema': 'repair_shop'}
    component_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    serial_number = db.Column(db.String(100), unique=True, nullable=False)
    usage = db.Column(db.String(100), nullable=False)

class Supply(db.Model):
    __tablename__ = 'supplies'
    __table_args__ = (
        CheckConstraint('quantity > 0', name='quantity_check'),
        {'schema': 'repair_shop'}
    )
    supply_id = db.Column(db.Integer, primary_key=True)
    supplier_id = db.Column(db.Integer, db.ForeignKey('repair_shop.suppliers.supplier_id'), nullable=False)
    component_id = db.Column(db.Integer, db.ForeignKey('repair_shop.components.component_id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    placing_date = db.Column(db.Date, server_default=db.func.current_date())
    departure_date = db.Column(db.Date)

    supplier = relationship("Supplier", backref="supplies")
    component = relationship("Component", backref="supplies")

class Equipment(db.Model):
    __tablename__ = 'equipment'
    __table_args__ = (
        CheckConstraint(
            "type IN ('Монитор', 'Клавиатура', 'Мышь', 'Принтер', 'Сканер', 'Компьютер', 'Роутер', 'Хаб', 'Источник питания', 'Микроскоп', 'Паяльник', 'Cтол', 'Кресло', 'Коврик', 'Лабораторный блок питания', 'Натфиль', 'Отвертка', 'Настольная лампа')", 
            name='equipment_type_check'
        ),
        CheckConstraint('quantity > 0', name='quantity_check'),
        {'schema': 'repair_shop'}
    )
    equipment_id = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.String(50), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    purchase_date = db.Column(db.Date, nullable=False)

class CallbackOrder(db.Model):
    __tablename__ = 'callback_orders'
    __table_args__ = (
        CheckConstraint("phone_number ~ '^8[0-9]{10}$'", name='phone_number_format_check'),
        {'schema': 'repair_shop'}
    )
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    phone_number = db.Column(db.String(50), nullable=False)
    model = db.Column(db.String(100), nullable=False)
    defect = db.Column(db.String(255), nullable=False)

class CallbackComputerBuild(db.Model):
    __tablename__ = 'callback_computer_builds'
    __table_args__ = (
        CheckConstraint("phone_number ~ '^8[0-9]{10}$'", name='phone_number_format_check'),
        {'schema': 'repair_shop'}
    )
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    phone_number = db.Column(db.String(50), nullable=False)
    budget = db.Column(db.Numeric(10, 2))
    usage_tasks = db.Column(db.Text)
    build_preferences = db.Column(db.Text)

class Password(db.Model):
    __tablename__ = 'passwords'
    __table_args__ = {'schema': 'repair_shop'}
    password_id = db.Column(db.Integer, primary_key=True)
    hashed_password = db.Column(db.Text, nullable=False)

class Role(db.Model):
    __tablename__ = 'roles'
    __table_args__ = (
        CheckConstraint(
            "name IN ('Инженер', 'Приемщик', 'Владелец', 'Администратор баз данных')",
            name='role_name_check'
        ),
        {'schema': 'repair_shop'}
    )
    role_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

class Specialization(db.Model):
    __tablename__ = 'specializations'
    __table_args__ = (
        CheckConstraint(
            "name IN ('Видеокарта', 'Ноутбук', 'Материнская плата', 'Системный блок', 'Сборщик системных блоков', 'Владелец', 'Приемщик', 'Администратор баз данных')",
            name='specialization_name_check'
        ),
        {'schema': 'repair_shop'}
    )
    specialization_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

class Employee(db.Model):
    __tablename__ = 'employees'
    __table_args__ = {'schema': 'repair_shop'}
    employee_id = db.Column(db.Integer, primary_key=True)
    password_id = db.Column(db.Integer, db.ForeignKey('repair_shop.passwords.password_id'))
    role_id = db.Column(db.Integer, db.ForeignKey('repair_shop.roles.role_id'), nullable=False)
    specialization_id = db.Column(db.Integer, db.ForeignKey('repair_shop.specializations.specialization_id'), nullable=False)
    fname = db.Column(db.String(50), nullable=False)
    lname = db.Column(db.String(50), nullable=False)
    mname = db.Column(db.String(50))
    passport_number = db.Column(db.Text)
    login = db.Column(db.String(255), unique=True, nullable=False)

    password = relationship("Password", backref="employees")
    role = relationship("Role", backref="employees")
    specialization = relationship("Specialization", backref="employees")

class Client(db.Model):
    __tablename__ = 'clients'
    __table_args__ = {'schema': 'repair_shop'}
    client_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.Text, nullable=False) 
    phone_number = db.Column(db.Text, nullable=False) 

class Device(db.Model):
    __tablename__ = 'devices'
    __table_args__ = (
        CheckConstraint(
            "type IN ('Ноутбук', 'Видеокарта', 'Материнская плата', 'Системный блок')",
            name='device_type_check'
        ),
        {'schema': 'repair_shop'}
    )
    device_id = db.Column(db.Integer, primary_key=True)
    client_id = db.Column(db.Integer, db.ForeignKey('repair_shop.clients.client_id'), nullable=False)
    type = db.Column(db.String(50), nullable=False)
    model = db.Column(db.String(255), nullable=False)
    serial_number = db.Column(db.String(255), nullable=False)

    client = relationship("Client", backref="devices")

class Order(db.Model):
    __tablename__ = 'orders'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Создан', 'В работе', 'Готов к выдаче', 'Завершен')",
            name='order_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    order_id = db.Column(db.Integer, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('repair_shop.devices.device_id'), nullable=False)
    client_id = db.Column(db.Integer, db.ForeignKey('repair_shop.clients.client_id'), nullable=False)
    engineer_id = db.Column(db.Integer, db.ForeignKey('repair_shop.employees.employee_id'), nullable=False)
    defect = db.Column(db.String(255))
    status = db.Column(db.String(50), nullable=False, default='Создан')
    cost = db.Column(db.Numeric(10, 2))
    creation_date = db.Column(db.Date, nullable=False, server_default=db.func.current_date())

    device = relationship("Device", backref="orders")
    client = relationship("Client", backref="orders")
    engineer = relationship("Employee", backref="orders")

class ComputerBuild(db.Model):
    __tablename__ = 'computer_builds'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Создан', 'В работе', 'Готов к выдаче', 'Завершен')",
            name='build_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    build_id = db.Column(db.Integer, primary_key=True)
    client_id = db.Column(db.Integer, db.ForeignKey('repair_shop.clients.client_id'), nullable=False)
    engineer_id = db.Column(db.Integer, db.ForeignKey('repair_shop.employees.employee_id'), nullable=False)
    components = db.Column(db.Text, nullable=False)
    components_cost = db.Column(db.Numeric(10, 2), nullable=False)
    service_fee = db.Column(db.Numeric(10, 2))
    status = db.Column(db.String(50), nullable=False, default='Создан')
    creation_date = db.Column(db.Date, nullable=False, server_default=db.func.current_date())

    client = relationship("Client", backref="computer_builds")
    engineer = relationship("Employee", backref="computer_builds")

class ArchivedOrder(db.Model):
    __tablename__ = 'archived_orders'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Завершен')",
            name='archived_order_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    id = db.Column(db.Integer, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('repair_shop.devices.device_id'))
    client_id = db.Column(db.Integer, db.ForeignKey('repair_shop.clients.client_id'))
    engineer_id = db.Column(db.Integer, db.ForeignKey('repair_shop.employees.employee_id'))
    status = db.Column(db.String(50), nullable=False)
    cost = db.Column(db.Numeric(10, 2))
    creation_date = db.Column(db.Date, nullable=False)
    completion_date = db.Column(db.Date, nullable=False, server_default=db.func.current_date())

    client = relationship("Client", backref="archived_orders")
    device = relationship("Device", backref="archived_orders")
    engineer = relationship("Employee", backref="archived_orders")

class ArchivedComputerBuild(db.Model):
    __tablename__ = 'archived_computer_builds'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Завершен')",
            name='archived_build_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    id = db.Column(db.Integer, primary_key=True)
    client_id = db.Column(db.Integer, db.ForeignKey('repair_shop.clients.client_id'))
    engineer_id = db.Column(db.Integer, db.ForeignKey('repair_shop.employees.employee_id'))
    components = db.Column(db.Text, nullable=False)
    components_cost = db.Column(db.Numeric(10, 2), nullable=False)
    service_fee = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.String(50), nullable=False)
    creation_date = db.Column(db.Date, nullable=False)
    completion_date = db.Column(db.Date, nullable=False, server_default=db.func.current_date())

    client = relationship("Client", backref="archived_computer_builds")
    engineer = relationship("Employee", backref="archived_computer_builds")
