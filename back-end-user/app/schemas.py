from pydantic import BaseModel, Field, field_validator
from typing import Optional, List
from datetime import date
import re
from decimal import Decimal

# Схемы для модели Supplier
class SupplierBase(BaseModel):
    type: str
    name: str
    address: str
    contact_info: str

class Supplier(SupplierBase):
    supplier_id: int

    class Config:
        orm_mode = True

# Схемы для модели Component
class ComponentBase(BaseModel):
    name: str
    serial_number: str
    usage: str

class Component(ComponentBase):
    component_id: int

    class Config:
        orm_mode = True

# Схемы для модели Supply
class SupplyBase(BaseModel):
    supplier_id: int
    component_id: int
    quantity: int
    placing_date: Optional[date]
    departure_date: Optional[date]

class Supply(SupplyBase):
    supply_id: int

    class Config:
        orm_mode = True

# Схемы для модели Equipment
class EquipmentBase(BaseModel):
    type: str
    name: str
    quantity: int
    purchase_date: date

class Equipment(EquipmentBase):
    equipment_id: int

    class Config:
        orm_mode = True

# Схемы для модели CallbackOrder
class CallbackOrderBase(BaseModel):
    name: str = Field(..., max_length=255, description="Имя клиента")
    phone_number: str = Field(..., max_length=50, description="Номер телефона клиента")
    model: str = Field(..., max_length=100, description="Модель устройства")
    defect: str = Field(..., max_length=255, description="Описание дефекта")

    @field_validator('phone_number')
    def validate_phone_number(cls, v):
        if not re.match(r'^8[0-9]{10}$', v):
            raise ValueError('Номер телефона должен начинаться с 8 и содержать 11 цифр')
        return v

class CallbackOrderCreate(CallbackOrderBase):
    pass

class CallbackOrder(CallbackOrderBase):
    id: int

    class Config:
        orm_mode = True

# Схемы для модели CallbackComputerBuild
class CallbackComputerBuildBase(BaseModel):
    name: str = Field(..., max_length=255, description="Имя клиента")
    phone_number: str = Field(..., max_length=50, description="Номер телефона клиента")
    budget: Optional[Decimal] = Field(None, description="Бюджет на сборку компьютера")
    usage_tasks: Optional[str] = Field(None, description="Задачи, для которых будет использоваться компьютер")
    build_preferences: Optional[str] = Field(None, description="Предпочтения по сборке")

    @field_validator('phone_number')
    def validate_phone_number(cls, v):
        if not re.match(r'^8[0-9]{10}$', v):
            raise ValueError('Номер телефона должен начинаться с 8 и содержать 11 цифр')
        return v

class CallbackComputerBuildCreate(CallbackComputerBuildBase):
    pass

class CallbackComputerBuild(CallbackComputerBuildBase):
    id: int

    class Config:
        orm_mode = True

# Схемы для модели Password
class PasswordBase(BaseModel):
    hashed_password: str

class Password(PasswordBase):
    password_id: int

    class Config:
        orm_mode = True

# Схемы для модели Role
class RoleBase(BaseModel):
    name: str

class Role(RoleBase):
    role_id: int

    class Config:
        orm_mode = True

# Схемы для модели Specialization
class SpecializationBase(BaseModel):
    name: str

class Specialization(SpecializationBase):
    specialization_id: int

    class Config:
        orm_mode = True

# Схемы для модели Employee
class EmployeeBase(BaseModel):
    fname: str
    lname: str
    mname: Optional[str]
    passport_number: Optional[str]
    login: str

class Employee(EmployeeBase):
    employee_id: int
    password_id: Optional[int]
    role_id: int
    specialization_id: int

    class Config:
        orm_mode = True

# Схемы для модели Client
class ClientBase(BaseModel):
    name: str
    phone_number: str

class Client(ClientBase):
    client_id: int

    class Config:
        orm_mode = True

# Схемы для модели Device
class DeviceBase(BaseModel):
    type: str
    model: str
    serial_number: str

class Device(DeviceBase):
    device_id: int
    client_id: int

    class Config:
        orm_mode = True

# Схемы для модели Order
class OrderBase(BaseModel):
    defect: Optional[str]
    status: str
    cost: Optional[Decimal]
    creation_date: date

class Order(OrderBase):
    order_id: int
    device_id: int
    client_id: int
    engineer_id: int

    class Config:
        orm_mode = True

# Схемы для модели ComputerBuild
class ComputerBuildBase(BaseModel):
    components: str
    components_cost: Decimal
    service_fee: Optional[Decimal]
    status: str
    creation_date: date

class ComputerBuild(ComputerBuildBase):
    build_id: int
    client_id: int
    engineer_id: int

    class Config:
        orm_mode = True

# Схемы для модели ArchivedOrder
class ArchivedOrderBase(BaseModel):
    status: str
    cost: Optional[Decimal]
    creation_date: date
    completion_date: date

class ArchivedOrder(ArchivedOrderBase):
    id: int
    device_id: Optional[int]
    client_id: Optional[int]
    engineer_id: Optional[int]

    class Config:
        orm_mode = True

# Схемы для модели ArchivedComputerBuild
class ArchivedComputerBuildBase(BaseModel):
    components: str
    components_cost: Decimal
    service_fee: Decimal
    status: str
    creation_date: date
    completion_date: date

class ArchivedComputerBuild(ArchivedComputerBuildBase):
    id: int
    client_id: Optional[int]
    engineer_id: Optional[int]

    class Config:
        orm_mode = True
