from sqlalchemy.orm import Session
from app import models, schemas

# CRUD операции для модели Supplier
def get_supplier(db: Session, supplier_id: int):
    return db.query(models.Supplier).filter(models.Supplier.supplier_id == supplier_id).first()

def get_suppliers(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Supplier).offset(skip).limit(limit).all()

# CRUD операции для модели Component
def get_component(db: Session, component_id: int):
    return db.query(models.Component).filter(models.Component.component_id == component_id).first()

def get_components(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Component).offset(skip).limit(limit).all()

# CRUD операции для модели Supply
def get_supply(db: Session, supply_id: int):
    return db.query(models.Supply).filter(models.Supply.supply_id == supply_id).first()

def get_supplies(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Supply).offset(skip).limit(limit).all()

# CRUD операции для модели Equipment
def get_equipment(db: Session, equipment_id: int):
    return db.query(models.Equipment).filter(models.Equipment.equipment_id == equipment_id).first()

def get_equipments(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Equipment).offset(skip).limit(limit).all()

# CRUD операции для модели CallbackOrder
def create_callback_order(db: Session, callback_order: schemas.CallbackOrderCreate):
    db_callback_order = models.CallbackOrder(**callback_order.dict())
    db.add(db_callback_order)
    db.commit()
    db.refresh(db_callback_order)
    return db_callback_order

def get_callback_orders(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.CallbackOrder).offset(skip).limit(limit).all()

def get_callback_order(db: Session, callback_order_id: int):
    return db.query(models.CallbackOrder).filter(models.CallbackOrder.id == callback_order_id).first()

# CRUD операции для модели CallbackComputerBuild
def create_callback_computer_build(db: Session, callback_computer_build: schemas.CallbackComputerBuildCreate):
    db_callback_computer_build = models.CallbackComputerBuild(**callback_computer_build.dict())
    db.add(db_callback_computer_build)
    db.commit()
    db.refresh(db_callback_computer_build)
    return db_callback_computer_build

def get_callback_computer_builds(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.CallbackComputerBuild).offset(skip).limit(limit).all()

def get_callback_computer_build(db: Session, callback_computer_build_id: int):
    return db.query(models.CallbackComputerBuild).filter(models.CallbackComputerBuild.id == callback_computer_build_id).first()

# CRUD операции для модели Password
def get_password(db: Session, password_id: int):
    return db.query(models.Password).filter(models.Password.password_id == password_id).first()

def get_passwords(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Password).offset(skip).limit(limit).all()

# CRUD операции для модели Role
def get_role(db: Session, role_id: int):
    return db.query(models.Role).filter(models.Role.role_id == role_id).first()

def get_roles(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Role).offset(skip).limit(limit).all()

# CRUD операции для модели Specialization
def get_specialization(db: Session, specialization_id: int):
    return db.query(models.Specialization).filter(models.Specialization.specialization_id == specialization_id).first()

def get_specializations(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Specialization).offset(skip).limit(limit).all()

# CRUD операции для модели Employee
def get_employee(db: Session, employee_id: int):
    return db.query(models.Employee).filter(models.Employee.employee_id == employee_id).first()

def get_employees(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Employee).offset(skip).limit(limit).all()

# CRUD операции для модели Client
def get_client(db: Session, client_id: int):
    return db.query(models.Client).filter(models.Client.client_id == client_id).first()

def get_clients(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Client).offset(skip).limit(limit).all()

# CRUD операции для модели Device
def get_device(db: Session, device_id: int):
    return db.query(models.Device).filter(models.Device.device_id == device_id).first()

def get_devices(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Device).offset(skip).limit(limit).all()

# Обновленные CRUD операции для модели Order
def get_order(db: Session, order_id: int):
    return db.query(models.Order).join(models.Device).join(models.Client).join(models.Employee).filter(models.Order.order_id == order_id).first()

def get_orders(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Order).join(models.Device).join(models.Client).join(models.Employee).offset(skip).limit(limit).all()

# Обновленные CRUD операции для модели ComputerBuild
def get_computer_build(db: Session, build_id: int):
    return db.query(models.ComputerBuild).join(models.Client).join(models.Employee).filter(models.ComputerBuild.build_id == build_id).first()

def get_computer_builds(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.ComputerBuild).join(models.Client).join(models.Employee).offset(skip).limit(limit).all()

# CRUD операции для модели ArchivedOrder
def get_archived_order(db: Session, archived_order_id: int):
    return db.query(models.ArchivedOrder).filter(models.ArchivedOrder.id == archived_order_id).first()

def get_archived_orders(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.ArchivedOrder).offset(skip).limit(limit).all()

# CRUD операции для модели ArchivedComputerBuild
def get_archived_computer_build(db: Session, archived_computer_build_id: int):
    return db.query(models.ArchivedComputerBuild).filter(models.ArchivedComputerBuild.id == archived_computer_build_id).first()

def get_archived_computer_builds(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.ArchivedComputerBuild).offset(skip).limit(limit).all()
