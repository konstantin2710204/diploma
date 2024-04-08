# Используем базовый образ Python
FROM python:3.12-alpine

WORKDIR /app

# Установка зависимостей
RUN pip install fastapi uvicorn

# Копируем код в контейнер
COPY . .

# Открываем порт 80 для веб-сервера
EXPOSE 80

# Запускаем сервер с помощью uvicorn приложения из main.py
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
