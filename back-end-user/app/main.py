from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .routers import router

# Create a FastAPI instance
app = FastAPI()

# Database setup
SQLALCHEMY_DATABASE_URL = "postgresql://postgres:password@localhost:5432/repair_shop"
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

# Dependency for database sessions
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Include routers
app.include_router(router)

# API endpoints
@app.get("/orders/")
def read_orders(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    orders = db.execute("SELECT * FROM orders OFFSET :skip LIMIT :limit", {'skip': skip, 'limit': limit}).fetchall()
    return orders

class RepairRequest(BaseModel):
    name: str
    phone: str

class ContactRequest(BaseModel):
    name: str
    phone: str
    budget: str
    task: str
    preferences: str

@app.post("/repair")
async def create_repair_request(request: RepairRequest):
    # Add logic for processing the repair request
    return {"message": "Repair request received", "data": request.dict()}

@app.post("/contact")
async def create_contact_request(request: ContactRequest):
    # Add logic for processing contact data
    return {"message": "Contact information received", "data": request.dict()}

@app.get("/")
def read_root():
    return {"message": "Welcome to the Service Center API"}
