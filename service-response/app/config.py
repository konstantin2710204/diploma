import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'секретный_ключ')
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'postgresql://postgres:password@172.17.0.2:5432/repair_shop')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
