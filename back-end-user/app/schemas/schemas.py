from pydantic import BaseModel, Field

class CallbackOrderSchema(BaseModel):
    name: str = Field(..., description="Имя клиента")
    phone_number: str = Field(..., description="Номер телефона клиента")

class CallbackComputerBuildSchema(BaseModel):
    name: str = Field(..., description="Имя клиента")
    phone_number: str = Field(..., description="Номер телефона клиента")
    budget: float = Field(..., description="Бюджет на сборку")
    usage_tasks: str = Field(..., description="Задачи использования компьютера")
    build_preferences: str = Field(..., description="Предпочтения по сборке")

class EmployeeSchema(BaseModel):
    id: int
    name: str
    role: str
    specialization: str
    login: str

class ClientSchema(BaseModel):
    id: int
    name: str
    contact_info: str

class DeviceSchema(BaseModel):
    id: int
    type: str
    model: str
    serial_number: str

class OrderSchema(BaseModel):
    id: int
    client_id: int
    device_id: int
    status: str
    engineer_id: int
    creation_date: str
    cost: float

class ComputerBuildSchema(BaseModel):
    id: int
    engineer_id: int
    client_id: int
    components: str
    components_cost: float
    service_fee: float
    creation_date: str
    status: str

class ArchivedOrderSchema(BaseModel):
    id: int
    client_id: int
    device_id: int
    status: str
    engineer_id: int
    creation_date: str
    completion_date: str
    cost: float

class ArchivedComputerBuildSchema(BaseModel):
    id: int
    engineer_id: int
    client_id: int
    components: str
    components_cost: float
    service_fee: float
    creation_date: str
    completion_date: str
    status: str    