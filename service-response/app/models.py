from flask import current_app
from sqlalchemy import ForeignKey
from sqlalchemy.sql import text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property
from . import db

class CallbackOrder(db.Model):
    __tablename__ = 'callback_orders'
    __table_args__ = {'schema': 'repair_shop'}
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    phone_number = db.Column(db.String(50), nullable=False)

class CallbackComputerBuild(db.Model):
    __tablename__ = 'callback_computer_builds'
    __table_args__ = {'schema': 'repair_shop'}
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

class Employee(db.Model):
    __tablename__ = 'employees'
    __table_args__ = {'schema': 'repair_shop'}
    employee_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(50), nullable=False)
    specialization = db.Column(db.String(255))
    login = db.Column(db.String(255), unique=True, nullable=False)
    password_id = db.Column(db.Integer, db.ForeignKey('repair_shop.passwords.password_id'))
    password = relationship("Password", backref="employees")

class Client(db.Model):
    __tablename__ = 'clients'
    __table_args__ = {'schema': 'repair_shop'}
    client_id = db.Column(db.Integer, primary_key=True)
    _name = db.Column('name', db.Text, nullable=False)  # Assuming encrypted storage
    _contact_info = db.Column('contact_info',db.Text, nullable=False)  # Assuming encrypted storage

    @hybrid_property
    def name(self):
        query = text(
            "SELECT repair_shop.pgp_sym_decrypt(name::bytea, :key) AS name "
            "FROM repair_shop.clients WHERE client_id = :client_id"
        )
        result_name =  db.session.execute(
            query,
            {'client_id': self.client_id, 'key': current_app.config['ENCRYPTION_KEY']}
        ).scalar()
        return result_name

    @hybrid_property
    def contact_info(self):
        query = text(
            "SELECT repair_shop.pgp_sym_decrypt(contact_info::bytea, :key) AS contact_info "
            "FROM repair_shop.clients WHERE client_id = :client_id"
        )
        result_contact_info = db.session.execute(
            query,
            {'client_id': self.client_id, 'key': current_app.config['ENCRYPTION_KEY']}
        ).scalar()
        return result_contact_info

class Device(db.Model):
    __tablename__ = 'devices'
    __table_args__ = {'schema': 'repair_shop'}
    device_id = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.String(50), nullable=False)
    model = db.Column(db.String(255), nullable=False)
    serial_number = db.Column(db.String(255), nullable=False)

class Order(db.Model):
    __tablename__ = 'orders'
    __table_args__ = {'schema': 'repair_shop'}
    order_id = db.Column(db.Integer, primary_key=True)
    client_id = db.Column(db.Integer, ForeignKey('repair_shop.clients.client_id'))
    device_id = db.Column(db.Integer, ForeignKey('repair_shop.devices.device_id'))
    status = db.Column(db.String(50), default='создан')
    engineer_id = db.Column(db.Integer, ForeignKey('repair_shop.employees.employee_id'))
    creation_date = db.Column(db.Date, nullable=False)
    cost = db.Column(db.Numeric(10, 2))
    client = relationship("Client", backref="orders")
    device = relationship("Device", backref="orders")
    engineer = relationship("Employee", backref="orders")

class ComputerBuild(db.Model):
    __tablename__ = 'computer_builds'
    __table_args__ = {'schema': 'repair_shop'}
    build_id = db.Column(db.Integer, primary_key=True)
    engineer_id = db.Column(db.Integer, ForeignKey('repair_shop.employees.employee_id'))
    client_id = db.Column(db.Integer, ForeignKey('repair_shop.clients.client_id'))
    components = db.Column(db.Text, nullable=False)
    components_cost = db.Column(db.Numeric(10, 2), nullable=False)
    service_fee = db.Column(db.Numeric(10, 2))
    creation_date = db.Column(db.Date, nullable=False)
    status = db.Column(db.String(50), default='создан')
    client = relationship("Client", backref="computer_builds")
    engineer = relationship("Employee", backref="computer_builds")

class ArchivedOrder(db.Model):
    __tablename__ = 'archived_orders'
    __table_args__ = {'schema': 'repair_shop'}
    order_id = db.Column(db.Integer, primary_key=True)
    client_id = db.Column(db.Integer, ForeignKey('repair_shop.clients.client_id'))
    device_id = db.Column(db.Integer, ForeignKey('repair_shop.devices.device_id'))
    status = db.Column(db.String(50), nullable=False)
    engineer_id = db.Column(db.Integer, ForeignKey('repair_shop.employees.employee_id'))
    creation_date = db.Column(db.Date, nullable=False)
    completion_date = db.Column(db.Date, nullable=False)
    client = relationship("Client", backref="archived_orders")
    device = relationship("Device", backref="archived_orders")
    engineer = relationship("Employee", backref="archived_orders")

class ArchivedComputerBuild(db.Model):
    __tablename__ = 'archived_computer_builds'
    __table_args__ = {'schema': 'repair_shop'}
    build_id = db.Column(db.Integer, primary_key=True)
    engineer_id = db.Column(db.Integer, ForeignKey('repair_shop.employees.employee_id'))
    client_id = db.Column(db.Integer, ForeignKey('repair_shop.clients.client_id'))
    components = db.Column(db.Text, nullable=False)
    components_cost = db.Column(db.Numeric(10, 2), nullable=False)
    service_fee = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.String(50), nullable=False)
    completion_date = db.Column(db.Date, nullable=False)
    client = relationship("Client", backref="archived_computer_builds")
    engineer = relationship("Employee", backref="archived_computer_builds")
