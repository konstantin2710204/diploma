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

@router.get("/track-order", response_model=List[schemas.Order])
def track_orders(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return crud.get_orders(db=db, skip=skip, limit=limit)

@router.get("/track-order/{order_id}", response_model=schemas.Order)
def track_order(order_id: int, db: Session = Depends(get_db)):
    db_order = crud.get_order(db=db, order_id=order_id)
    if db_order is None:
        raise HTTPException(status_code=404, detail="Order not found")
    return db_order

@router.get("/track-order/build/{build_id}", response_model=schemas.ComputerBuild)
def track_computer_build(build_id: int, db: Session = Depends(get_db)):
    db_build = crud.get_computer_build(db=db, build_id=build_id)
    if db_build is None:
        raise HTTPException(status_code=404, detail="Computer build not found")
    return db_build
