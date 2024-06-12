from fastapi import FastAPI
from app.models import Base
from app.database import engine
from app.routers import callbacks, tracking

# Создание таблиц в базе данных (если они еще не созданы)
Base.metadata.create_all(bind=engine)

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to the Repair Shop API"}

# Подключение маршрутов
app.include_router(callbacks.router, prefix="/callbacks", tags=["callbacks"])
app.include_router(tracking.router, prefix="/tracking", tags=["tracking"])
