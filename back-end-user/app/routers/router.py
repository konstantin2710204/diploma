from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..schemas import DeviceCreate, OrderCreate, ArchivedOrderCreate
from ..models import Device, Order, ArchivedOrder
from ..dependencies import get_db

router = APIRouter()

@router.post("/devices/", response_model=Device)
def create_device(device: DeviceCreate, db: Session = Depends(get_db)):
    db_device = Device(**device.dict())
    db.add(db_device)
    db.commit()
    db.refresh(db_device)
    return db_device

@router.post("/orders/", response_model=Order)
def create_order(order: OrderCreate, db: Session = Depends(get_db)):
    db_order = Order(**order.dict())
    db.add(db_order)
    db.commit()
    db.refresh(db_order)
    return db_order

@router.post("/archived_orders/", response_model=ArchivedOrder)
def create_archived_order(archived_order: ArchivedOrderCreate, db: Session = Depends(get_db)):
    db_archived_order = ArchivedOrder(**archived_order.dict())
    db.add(db_archived_order)
    db.commit()
    db.refresh(db_archived_order)
    return db_archived_order
