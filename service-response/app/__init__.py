# app/__init__.py
import os
from flask import Flask
from config import get_config
from flask_bcrypt import Bcrypt
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv

db = SQLAlchemy()
bcrypt = Bcrypt()
load_dotenv()

def create_app(config_name='DevConfig'):
    app = Flask(__name__)
    app.config.from_object(f'config.{config_name}')  # Предполагается, что конфигурация находится в файле config.py
    app.config['ENCRYPTION_KEY'] = os.getenv('ENCRYPTION_KEY')
    
    db.init_app(app)  # Инициализация SQLAlchemy с приложением Flask
    bcrypt.init_app(app)

    app.bcrypt = bcrypt

    from .routers import main as main_blueprint
    app.register_blueprint(main_blueprint)

    return app
