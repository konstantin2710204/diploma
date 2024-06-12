from sqlalchemy import Column, Integer, String, Text, Numeric, Date, ForeignKey, CheckConstraint, func
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Supplier(Base):
    __tablename__ = 'suppliers'
    __table_args__ = (
        CheckConstraint(
            "type IN ('Разъемы', 'Конденсаторы', 'Резисторы', 'Видеопамять', 'Чипы GPU', 'Чипы CPU', 'Чипсеты', 'Сокеты', 'Донорские компоненты', 'Термопасты', 'Термопаста с фазовым переходом', 'Термопрокладки', 'Жидкие термопрокладки', 'Салфетки', 'Обезжириватель', 'Канифоль', 'BGA шарики', 'Медная проволока')", 
            name='supplier_type_check'
        ),
        {'schema': 'repair_shop'}
    )
    supplier_id = Column(Integer, primary_key=True)
    type = Column(String(30), nullable=False)
    name = Column(Text, nullable=False)
    address = Column(Text, nullable=False)
    contact_info = Column(Text, nullable=False)

class Component(Base):
    __tablename__ = 'components'
    __table_args__ = {'schema': 'repair_shop'}
    component_id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False)
    serial_number = Column(String(100), unique=True, nullable=False)
    usage = Column(String(100), nullable=False)

class Supply(Base):
    __tablename__ = 'supplies'
    __table_args__ = (
        CheckConstraint('quantity > 0', name='quantity_check'),
        {'schema': 'repair_shop'}
    )
    supply_id = Column(Integer, primary_key=True)
    supplier_id = Column(Integer, ForeignKey('repair_shop.suppliers.supplier_id'), nullable=False)
    component_id = Column(Integer, ForeignKey('repair_shop.components.component_id'), nullable=False)
    quantity = Column(Integer, nullable=False)
    placing_date = Column(Date, server_default=func.current_date())
    departure_date = Column(Date)

    supplier = relationship("Supplier", back_populates="supplies")
    component = relationship("Component", back_populates="supplies")

Supplier.supplies = relationship("Supply", order_by=Supply.supply_id, back_populates="supplier")
Component.supplies = relationship("Supply", order_by=Supply.supply_id, back_populates="component")

class Equipment(Base):
    __tablename__ = 'equipment'
    __table_args__ = (
        CheckConstraint(
            "type IN ('Монитор', 'Клавиатура', 'Мышь', 'Принтер', 'Сканер', 'Компьютер', 'Роутер', 'Хаб', 'Источник питания', 'Микроскоп', 'Паяльник', 'Cтол', 'Кресло', 'Коврик', 'Лабораторный блок питания', 'Натфиль', 'Отвертка', 'Настольная лампа')", 
            name='equipment_type_check'
        ),
        CheckConstraint('quantity > 0', name='quantity_check'),
        {'schema': 'repair_shop'}
    )
    equipment_id = Column(Integer, primary_key=True)
    type = Column(String(50), nullable=False)
    name = Column(String(50), nullable=False)
    quantity = Column(Integer, nullable=False)
    purchase_date = Column(Date, nullable=False)

class CallbackOrder(Base):
    __tablename__ = 'callback_orders'
    __table_args__ = (
        CheckConstraint("phone_number ~ '^8[0-9]{10}$'", name='phone_number_format_check'),
        {'schema': 'repair_shop'}
    )
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    phone_number = Column(String(50), nullable=False)
    model = Column(String(100), nullable=False)
    defect = Column(String(255), nullable=False)

class CallbackComputerBuild(Base):
    __tablename__ = 'callback_computer_builds'
    __table_args__ = (
        CheckConstraint("phone_number ~ '^8[0-9]{10}$'", name='phone_number_format_check'),
        {'schema': 'repair_shop'}
    )
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    phone_number = Column(String(50), nullable=False)
    budget = Column(Numeric(10, 2))
    usage_tasks = Column(Text)
    build_preferences = Column(Text)

class Password(Base):
    __tablename__ = 'passwords'
    __table_args__ = {'schema': 'repair_shop'}
    password_id = Column(Integer, primary_key=True)
    hashed_password = Column(Text, nullable=False)

class Role(Base):
    __tablename__ = 'roles'
    __table_args__ = (
        CheckConstraint(
            "name IN ('Инженер', 'Приемщик', 'Владелец', 'Администратор баз данных')",
            name='role_name_check'
        ),
        {'schema': 'repair_shop'}
    )
    role_id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)

class Specialization(Base):
    __tablename__ = 'specializations'
    __table_args__ = (
        CheckConstraint(
            "name IN ('Видеокарта', 'Ноутбук', 'Материнская плата', 'Системный блок', 'Сборщик системных блоков', 'Владелец', 'Приемщик', 'Администратор баз данных')",
            name='specialization_name_check'
        ),
        {'schema': 'repair_shop'}
    )
    specialization_id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)

class Employee(Base):
    __tablename__ = 'employees'
    __table_args__ = {'schema': 'repair_shop'}
    employee_id = Column(Integer, primary_key=True)
    password_id = Column(Integer, ForeignKey('repair_shop.passwords.password_id'))
    role_id = Column(Integer, ForeignKey('repair_shop.roles.role_id'), nullable=False)
    specialization_id = Column(Integer, ForeignKey('repair_shop.specializations.specialization_id'), nullable=False)
    fname = Column(String(50), nullable=False)
    lname = Column(String(50), nullable=False)
    mname = Column(String(50))
    passport_number = Column(Text)
    login = Column(String(255), unique=True, nullable=False)

    password = relationship("Password", back_populates="employees")
    role = relationship("Role", back_populates="employees")
    specialization = relationship("Specialization", back_populates="employees")

Password.employees = relationship("Employee", order_by=Employee.employee_id, back_populates="password")
Role.employees = relationship("Employee", order_by=Employee.employee_id, back_populates="role")
Specialization.employees = relationship("Employee", order_by=Employee.employee_id, back_populates="specialization")

class Client(Base):
    __tablename__ = 'clients'
    __table_args__ = {'schema': 'repair_shop'}
    client_id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(Text, nullable=False)
    phone_number = Column(Text, nullable=False)

class Device(Base):
    __tablename__ = 'devices'
    __table_args__ = (
        CheckConstraint(
            "type IN ('Ноутбук', 'Видеокарта', 'Материнская плата', 'Системный блок')",
            name='device_type_check'
        ),
        {'schema': 'repair_shop'}
    )
    device_id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'), nullable=False)
    type = Column(String(50), nullable=False)
    model = Column(String(255), nullable=False)
    serial_number = Column(String(255), nullable=False)

    client = relationship("Client", back_populates="devices")

Client.devices = relationship("Device", order_by=Device.device_id, back_populates="client")

class Order(Base):
    __tablename__ = 'orders'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Создан', 'В работе', 'Готов к выдаче', 'Завершен')",
            name='order_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    order_id = Column(Integer, primary_key=True)
    device_id = Column(Integer, ForeignKey('repair_shop.devices.device_id'), nullable=False)
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'), nullable=False)
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'), nullable=False)
    defect = Column(String(255))
    status = Column(String(50), nullable=False, default='Создан')
    cost = Column(Numeric(10, 2))
    creation_date = Column(Date, nullable=False, server_default=func.current_date())

    device = relationship("Device", back_populates="orders")
    client = relationship("Client", back_populates="orders")
    engineer = relationship("Employee", back_populates="orders")

Device.orders = relationship("Order", order_by=Order.order_id, back_populates="device")
Client.orders = relationship("Order", order_by=Order.order_id, back_populates="client")
Employee.orders = relationship("Order", order_by=Order.order_id, back_populates="engineer")

class ComputerBuild(Base):
    __tablename__ = 'computer_builds'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Создан', 'В работе', 'Готов к выдаче', 'Завершен')",
            name='build_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    build_id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'), nullable=False)
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'), nullable=False)
    components = Column(Text, nullable=False)
    components_cost = Column(Numeric(10, 2), nullable=False)
    service_fee = Column(Numeric(10, 2))
    status = Column(String(50), nullable=False, default='Создан')
    creation_date = Column(Date, nullable=False, server_default=func.current_date())

    client = relationship("Client", back_populates="computer_builds")
    engineer = relationship("Employee", back_populates="computer_builds")

Client.computer_builds = relationship("ComputerBuild", order_by=ComputerBuild.build_id, back_populates="client")
Employee.computer_builds = relationship("ComputerBuild", order_by=ComputerBuild.build_id, back_populates="engineer")

class ArchivedOrder(Base):
    __tablename__ = 'archived_orders'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Завершен')",
            name='archived_order_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    id = Column(Integer, primary_key=True)
    device_id = Column(Integer, ForeignKey('repair_shop.devices.device_id'))
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'))
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'))
    status = Column(String(50), nullable=False)
    cost = Column(Numeric(10, 2))
    creation_date = Column(Date, nullable=False)
    completion_date = Column(Date, nullable=False, server_default=func.current_date())

    client = relationship("Client", back_populates="archived_orders")
    device = relationship("Device", back_populates="archived_orders")
    engineer = relationship("Employee", back_populates="archived_orders")

Device.archived_orders = relationship("ArchivedOrder", order_by=ArchivedOrder.id, back_populates="device")
Client.archived_orders = relationship("ArchivedOrder", order_by=ArchivedOrder.id, back_populates="client")
Employee.archived_orders = relationship("ArchivedOrder", order_by=ArchivedOrder.id, back_populates="engineer")

class ArchivedComputerBuild(Base):
    __tablename__ = 'archived_computer_builds'
    __table_args__ = (
        CheckConstraint(
            "status IN ('Завершен')",
            name='archived_build_status_check'
        ),
        {'schema': 'repair_shop'}
    )
    id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'))
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'))
    components = Column(Text, nullable=False)
    components_cost = Column(Numeric(10, 2), nullable=False)
    service_fee = Column(Numeric(10, 2), nullable=False)
    status = Column(String(50), nullable=False)
    creation_date = Column(Date, nullable=False)
    completion_date = Column(Date, nullable=False, server_default=func.current_date())

    client = relationship("Client", back_populates="archived_computer_builds")
    engineer = relationship("Employee", back_populates="archived_computer_builds")

Client.archived_computer_builds = relationship("ArchivedComputerBuild", order_by=ArchivedComputerBuild.id, back_populates="client")
Employee.archived_computer_builds = relationship("ArchivedComputerBuild", order_by=ArchivedComputerBuild.id, back_populates="engineer")
