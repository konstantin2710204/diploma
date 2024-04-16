# app/routers/router.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from ..dependencies.database import get_db
from ..models import Employee, Client, Device, Order, ArchivedOrder, ComputerBuild, ArchivedComputerBuild
from ..schemas import EmployeeSchema, ClientSchema, DeviceSchema, OrderSchema, ArchivedOrderSchema, ComputerBuildSchema, ArchivedComputerBuildSchema

router = APIRouter()

# Employees
@router.get("/employees/", response_model=List[EmployeeSchema])
def read_employees(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    employees = db.query(Employee).offset(skip).limit(limit).all()
    return employees

# Clients
@router.get("/clients/", response_model=List[ClientSchema])
def read_clients(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    clients = db.query(Client).offset(skip).limit(limit).all()
    return clients

# Devices
@router.get("/devices/", response_model=List[DeviceSchema])
def read_devices(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    devices = db.query(Device).offset(skip).limit(limit).all()
    return devices

# Orders
@router.get("/orders/", response_model=List[OrderSchema])
def read_orders(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    orders = db.query(Order).offset(skip).limit(limit).all()
    return orders

# Archived Orders
@router.get("/archived_orders/", response_model=List[ArchivedOrderSchema])
def read_archived_orders(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    archived_orders = db.query(ArchivedOrder).offset(skip).limit(limit).all()
    return archived_orders

# Computer Builds
@router.get("/computer_builds/", response_model=List[ComputerBuildSchema])
def read_computer_builds(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    computer_builds = db.query(ComputerBuild).offset(skip).limit(limit).all()
    return computer_builds

# Archived Computer Builds
@router.get("/archived_computer_builds/", response_model=List[ArchivedComputerBuildSchema])
def read_archived_computer_builds(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    archived_computer_builds = db.query(ArchivedComputerBuild).offset(skip).limit(limit).all()
    return archived_computer_builds
