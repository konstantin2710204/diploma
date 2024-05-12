from pydantic import BaseSettings

class Settings(BaseSettings):
    database_url: str = "postgresql://postgres:password@localhost/repair_shop"
    secret_key: str = "secret_key"

    class Config:
        env_file = ".env"
        env_file_encoding = 'utf-8'

settings = Settings()
