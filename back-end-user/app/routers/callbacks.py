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

@router.post("/create-callback-order", response_model=schemas.CallbackOrder)
def create_callback_order(callback_order: schemas.CallbackOrderCreate, db: Session = Depends(get_db)):
    return crud.create_callback_order(db=db, callback_order=callback_order)

@router.post("/create-callback-build", response_model=schemas.CallbackComputerBuild)
def create_callback_computer_build(callback_computer_build: schemas.CallbackComputerBuildCreate, db: Session = Depends(get_db)):
    return crud.create_callback_computer_build(db=db, callback_computer_build=callback_computer_build)
