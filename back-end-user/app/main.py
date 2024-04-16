from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base 
from .dependencies.database import engine, Base
from .routers.router import router as api_router

Base.metadata.create_all(bind=engine)

# Create a FastAPI instance
app = FastAPI()

print(api_router)
app.include_router(api_router)

# Database setup
SQLALCHEMY_DATABASE_URL = "postgresql://postgres:password@172.17.0.2:5432/repair_shop"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# CORS middleware configuration
origins = [
    "http://localhost:3000",  # Allow frontend access
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router)

@app.get("/")
def read_root():
    return{"message": "Welcome to the Service Center API"}