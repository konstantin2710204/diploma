from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.models import Base
from app.database import engine
from app.routers import callbacks, tracking

# Создание таблиц в базе данных (если они еще не созданы)
Base.metadata.create_all(bind=engine)

app = FastAPI()

origins = [
    "*"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Repair Shop API"}

# Подключение маршрутов
app.include_router(callbacks.router, prefix="/api", tags=["callbacks"])
app.include_router(tracking.router, prefix="/api", tags=["tracking"])
