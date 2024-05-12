from fastapi import FastAPI
from app.api.api import router as api_router
from app.database.session import create_db_and_tables

app = FastAPI(title="Service Center Backend", version="1.0")

@app.on_event("startup")
def startup_event():
    create_db_and_tables()  # Создаем таблицы при старте приложения, если они еще не созданы

app.include_router(api_router)
