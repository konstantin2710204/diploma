from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.schemas import CallbackOrderSchema, CallbackComputerBuildSchema, OrderSchema, ComputerBuildSchema
from app.services.service import ServiceCenter
from app.database.session import SessionLocal

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/callback_orders/", response_model=CallbackOrderSchema, status_code=201)
def create_callback_order(callback_order: CallbackOrderSchema, db: Session = Depends(get_db)):
    return ServiceCenter.create_callback_order(db, callback_order)

@router.post("/callback_computer_builds/", response_model=CallbackComputerBuildSchema, status_code=201)
def create_callback_computer_build(callback_build: CallbackComputerBuildSchema, db: Session = Depends(get_db)):
    return ServiceCenter.create_callback_computer_build(db, callback_build)

@router.get("/order/{order_id}", response_model=OrderSchema, status_code=200)
def get_order(order: OrderSchema, db: Session = Depends(get_db)):
    return ServiceCenter.get_order(db, order)

@router.get("/build/{build_id}", response_model=OrderSchema, status_code=200)
def get_build(build: ComputerBuildSchema, db: Session = Depends(get_db)):
    return ServiceCenter.get_order(db, build)