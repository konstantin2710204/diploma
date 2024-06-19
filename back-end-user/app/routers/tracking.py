from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import models, schemas, crud
from app.database import SessionLocal

router = APIRouter()

# Зависимость для получения сессии базы данных
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/track-order", response_model=List[schemas.OrderInfo])
def track_orders(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    orders = crud.get_orders(db=db, skip=skip, limit=limit)
    return [
        schemas.OrderInfo(
            order_id=order.order_id,
            device_model=order.device.model,
            status=order.status,
            client_phone_number=order.client.phone_number,
            engineer_name=f"{order.engineer.fname} {order.engineer.lname}"
        )
        for order in orders
    ]

@router.get("/track-order/{order_id}", response_model=schemas.OrderInfo)
def track_order(order_id: int, db: Session = Depends(get_db)):
    order = crud.get_order(db=db, order_id=order_id)
    if order is None:
        raise HTTPException(status_code=404, detail="Order not found")
    return schemas.OrderInfo(
        order_id=order.order_id,
        device_model=order.device.model,
        status=order.status,
        client_phone_number=order.client.phone_number,
        engineer_name=f"{order.engineer.fname} {order.engineer.lname}"
    )

@router.get("/track-order/build/{build_id}", response_model=schemas.ComputerBuildInfo)
def track_computer_build(build_id: int, db: Session = Depends(get_db)):
    build = crud.get_computer_build(db=db, build_id=build_id)
    if build is None:
        raise HTTPException(status_code=404, detail="Computer build not found")
    return schemas.ComputerBuildInfo(
        build_id=build.build_id,
        status=build.status,
        client_phone_number=build.client.phone_number,
        engineer_name=f"{build.engineer.fname} {build.engineer.lname}"
    )
