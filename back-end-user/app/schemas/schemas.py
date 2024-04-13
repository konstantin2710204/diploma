from pydantic import BaseModel
from typing import Optional
from datetime import date

class DeviceBase(BaseModel):
    type: str
    model: str
    serial_number: str

class DeviceCreate(DeviceBase):
    pass

class Device(DeviceBase):
    id: int

    class Config:
        orm_mode = True

class OrderBase(BaseModel):
    device_id: int
    status: str
    creation_date: date
    completion_date: Optional[date] = None

class OrderCreate(OrderBase):
    pass

class Order(OrderBase):
    id: int
    device: Device

    class Config:
        orm_mode = True

class ArchivedOrderBase(BaseModel):
    device_id: int
    status: str
    creation_date: date
    completion_date: date

class ArchivedOrderCreate(ArchivedOrderBase):
    pass

class ArchivedOrder(ArchivedOrderBase):
    id: int
    device: Device

    class Config:
        orm_mode = True
