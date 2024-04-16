from pydantic import BaseModel, validator
import base64
from typing import Optional, List
from datetime import date

class PasswordSchema(BaseModel):
    password_id: int
    hashed_password: str

    class Config:
        orm_mode = True
        from_attributes = True

class EmployeeSchema(BaseModel):
    employee_id: int
    name: str
    role: str
    login: str
    password_id: int

    class Config:
        orm_mode = True
        from_attributes = True

class ClientSchema(BaseModel):
    client_id: int
    name: str  # Base64 encoded
    contact_info: str  # Base64 encoded

    class Config:
        orm_mode = True
        from_attributes = True

    @validator('name', 'contact_info', pre=True)
    def decode_base64(cls, v):
        return base64.b64decode(v).decode('utf-8')

    @validator('name', 'contact_info', pre=False)
    def encode_base64(cls, v):
        return base64.b64encode(v.encode('utf-8')).decode('utf-8')

class DeviceSchema(BaseModel):
    device_id: int
    type: str
    model: str
    serial_number: str

    class Config:
        orm_mode = True
        from_attributes = True

class OrderSchema(BaseModel):
    order_id: int
    client_id: int
    device_id: int
    status: str
    engineer_id: Optional[int]
    creation_date: date
    completion_date: Optional[date]

    class Config:
        orm_mode = True
        from_attributes = True

class ArchivedOrderSchema(BaseModel):
    order_id: int
    client_id: int
    device_id: int
    status: str
    engineer_id: int
    creation_date: date
    completion_date: date

    class Config:
        orm_mode = True
        from_attributes = True

class ComputerBuildSchema(BaseModel):
    build_id: int
    engineer_id: int
    client_id: int
    components: str
    components_cost: float
    service_fee: float
    status: str

    class Config:
        orm_mode = True
        from_attributes = True

class ArchivedComputerBuildSchema(BaseModel):
    build_id: int
    engineer_id: int
    client_id: int
    components: str
    components_cost: float
    service_fee: float
    status: str
    completion_date: date

    class Config:
        orm_mode = True
        from_attributes = True
