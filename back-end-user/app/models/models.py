from sqlalchemy import Column, Integer, String, ForeignKey, DECIMAL, Date, Text
from sqlalchemy.sql import text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property
from app.database.session import Base

class CallbackOrder(Base):
    __tablename__ = 'callback_orders'
    __table_args__ = {'schema': 'repair_shop'}
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    phone_number = Column(String(50), nullable=False)

class CallbackComputerBuild(Base):
    __tablename__ = 'callback_computer_builds'
    __table_args__ = {'schema': 'repair_shop'}
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    phone_number = Column(String(50), nullable=False)
    budget = Column(DECIMAL(10, 2))
    usage_tasks = Column(Text)
    build_preferences = Column(Text)

class Password(Base):
    __tablename__ = 'passwords'
    __table_args__ = {'schema': 'repair_shop'}
    password_id = Column(Integer, primary_key=True)
    hashed_password = Column(Text, nullable=False)

class Employee(Base):
    __tablename__ = 'employees'
    __table_args__ = {'schema': 'repair_shop'}
    employee_id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    role = Column(String(50), nullable=False)
    specialization = Column(String(255))
    login = Column(String(255), unique=True, nullable=False)
    password_id = Column(Integer, ForeignKey('repair_shop.passwords.password_id'))
    password = relationship("Password", backref="employees")

class Client(Base):
    __tablename__ = 'clients'
    __table_args__ = {'schema': 'repair_shop'}
    client_id = Column(Integer, primary_key=True, autoincrement=True)
    _name = Column('name', Text, nullable=False)  # Assuming encrypted storage
    _contact_info = Column('contact_info',Text, nullable=False)  # Assuming encrypted storage

    """
    @hybrid_property
    def name(self):
        query = text(
            "SELECT repair_shop.pgp_sym_decrypt(name::bytea, :key) AS name "
            "FROM repair_shop.clients WHERE client_id = :client_id"
        )
        result_name =  session.execute(
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
        result_contact_info = session.execute(
            query,
            {'client_id': self.client_id, 'key': current_app.config['ENCRYPTION_KEY']}
        ).scalar()
        return result_contact_info
    """
class Device(Base):
    __tablename__ = 'devices'
    __table_args__ = {'schema': 'repair_shop'}
    device_id = Column(Integer, primary_key=True)
    type = Column(String(50), nullable=False)
    model = Column(String(255), nullable=False)
    serial_number = Column(String(255), nullable=False)

class Order(Base):
    __tablename__ = 'orders'
    __table_args__ = {'schema': 'repair_shop'}
    order_id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'))
    device_id = Column(Integer, ForeignKey('repair_shop.devices.device_id'))
    status = Column(String(50), default='создан')
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'))
    creation_date = Column(Date, nullable=False)
    cost = Column(DECIMAL(10, 2))
    client = relationship("Client", backref="orders")
    device = relationship("Device", backref="orders")
    engineer = relationship("Employee", backref="orders")

class ComputerBuild(Base):
    __tablename__ = 'computer_builds'
    __table_args__ = {'schema': 'repair_shop'}
    build_id = Column(Integer, primary_key=True)
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'))
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'))
    components = Column(Text, nullable=False)
    components_cost = Column(DECIMAL(10, 2), nullable=False)
    service_fee = Column(DECIMAL(10, 2))
    creation_date = Column(Date, nullable=False)
    status = Column(String(50), default='создан')
    client = relationship("Client", backref="computer_builds")
    engineer = relationship("Employee", backref="computer_builds")

class ArchivedOrder(Base):
    __tablename__ = 'archived_orders'
    __table_args__ = {'schema': 'repair_shop'}
    order_id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'))
    device_id = Column(Integer, ForeignKey('repair_shop.devices.device_id'))
    status = Column(String(50), nullable=False)
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'))
    creation_date = Column(Date, nullable=False)
    completion_date = Column(Date, nullable=False)
    client = relationship("Client", backref="archived_orders")
    device = relationship("Device", backref="archived_orders")
    engineer = relationship("Employee", backref="archived_orders")

class ArchivedComputerBuild(Base):
    __tablename__ = 'archived_computer_builds'
    __table_args__ = {'schema': 'repair_shop'}
    build_id = Column(Integer, primary_key=True)
    engineer_id = Column(Integer, ForeignKey('repair_shop.employees.employee_id'))
    client_id = Column(Integer, ForeignKey('repair_shop.clients.client_id'))
    components = Column(Text, nullable=False)
    components_cost = Column(DECIMAL(10, 2), nullable=False)
    service_fee = Column(DECIMAL(10, 2), nullable=False)
    status = Column(String(50), nullable=False)
    completion_date = Column(Date, nullable=False)
    client = relationship("Client", backref="archived_computer_builds")
    engineer = relationship("Employee", backref="archived_computer_builds")
