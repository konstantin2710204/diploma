from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base

class Device(Base):
    __tablename__ = "devices"
    id = Column(Integer, primary_key=True, index=True)
    type = Column(String)
    model = Column(String)
    serial_number = Column(String)

class Order(Base):
    __tablename__ = "orders"
    id = Column(Integer, primary_key=True, index=True)
    device_id = Column(Integer, ForeignKey('devices.id'))
    status = Column(String)
    creation_date = Column(Date)
    completion_date = Column(Date)
    device = relationship("Device")

class ArchivedOrder(Base):
    __tablename__ = "archived_orders"
    id = Column(Integer, primary_key=True, index=True)
    device_id = Column(Integer, ForeignKey('devices.id'))
    status = Column(String)
    creation_date = Column(Date)
    completion_date = Column(Date)
    device = relationship("Device")
