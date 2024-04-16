# models/models.py
from sqlalchemy import Column, Integer, String, Date, Text, ForeignKey, DECIMAL, LargeBinary
from sqlalchemy.orm import relationship
from ..dependencies.database import Base

class Password(Base):
    __tablename__ = 'passwords'
    password_id = Column(Integer, primary_key=True)
    hashed_password = Column(Text, nullable=False)

class Employee(Base):
    __tablename__ = 'employees'
    employee_id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    role = Column(String(50), nullable=False)
    login = Column(String(255), unique=True, nullable=False)
    password_id = Column(Integer, ForeignKey('passwords.password_id'))
    password = relationship("Password")

class Client(Base):
    __tablename__ = 'clients'
    client_id = Column(Integer, primary_key=True)
    name = Column(LargeBinary, nullable=False)
    contact_info = Column(LargeBinary, nullable=False)

class Device(Base):
    __tablename__ = 'devices'
    device_id = Column(Integer, primary_key=True)
    type = Column(String(50), nullable=False)
    model = Column(String(255), nullable=False)
    serial_number = Column(String(255), nullable=False)

class Order(Base):
    __tablename__ = 'orders'
    order_id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('clients.client_id'))
    device_id = Column(Integer, ForeignKey('devices.device_id'))
    status = Column(String(50), default='создан')
    engineer_id = Column(Integer, ForeignKey('employees.employee_id'))
    creation_date = Column(Date, nullable=False)
    completion_date = Column(Date)
    client = relationship("Client")
    device = relationship("Device")
    engineer = relationship("Employee")

class ArchivedOrder(Base):
    __tablename__ = 'archived_orders'
    order_id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('clients.client_id'))
    device_id = Column(Integer, ForeignKey('devices.device_id'))
    status = Column(String(50), nullable=False)
    engineer_id = Column(Integer, ForeignKey('employees.employee_id'))
    creation_date = Column(Date, nullable=False)
    completion_date = Column(Date)
    client = relationship("Client")
    device = relationship("Device")
    engineer = relationship("Employee")

class ComputerBuild(Base):
    __tablename__ = 'computer_builds'
    build_id = Column(Integer, primary_key=True)
    engineer_id = Column(Integer, ForeignKey('employees.employee_id'))
    client_id = Column(Integer, ForeignKey('clients.client_id'))
    components = Column(Text, nullable=False)
    components_cost = Column(DECIMAL(10, 2), nullable=False)
    service_fee = Column(DECIMAL(10, 2))
    status = Column(String(50), default='создан')
    client = relationship("Client")
    engineer = relationship("Employee")

class ArchivedComputerBuild(Base):
    __tablename__ = 'archived_computer_builds'
    build_id = Column(Integer, primary_key=True)
    engineer_id = Column(Integer, ForeignKey('employees.employee_id'))
    client_id = Column(Integer, ForeignKey('clients.client_id'))
    components = Column(Text, nullable=False)
    components_cost = Column(DECIMAL(10, 2), nullable=False)
    service_fee = Column(DECIMAL(10, 2), nullable=False)
    status = Column(String(50), nullable=False)
    completion_date = Column(Date, nullable=False)
    client = relationship("Client")
    engineer = relationship("Employee")
