import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Общие конфигурации приложения."""
    SECRET_KEY = os.getenv('SECRET_KEY', 'secret_key')
    SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI')
    ENCRYPTION_KEY = os.getenv('ENCRYPTION_KEY')
    SQLALCHEMY_TRACK_MODIFICATIONS = False

class DevConfig(Config):
    """Конфигурации для разработки."""
    DEBUG = True
    SQLALCHEMY_ECHO = True  # Показывает SQL запросы, генерируемые SQLAlchemy

class TestingConfig(Config):
    """Конфигурации для тестирования."""
    TESTING = True
    SQLALCHEMY_ECHO = False

class ProductionConfig(Config):
    """Конфигурации для продакшн."""
    DEBUG = False
    SQLALCHEMY_ECHO = False

# Настройка для простого доступа в зависимости от окружения
config_by_name = dict(
    dev=DevConfig,
    test=TestingConfig,
    prod=ProductionConfig
)

def get_config(mode):
    """Возвращает конфигурационный класс для указанного режима."""
    return config_by_name.get(mode, ProductionConfig)  # Возвращаем продакшн конфигурацию по умолчанию
