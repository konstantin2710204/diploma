# Используем базовый образ Python
FROM python:3.12-alpine

WORKDIR /app

# Установка зависимостей
RUN pip install flask psycopg2-binary

# Копируем код в контейнер
COPY . .

# Открываем порт 80 для веб-сервера
EXPOSE 5000

# Запускаем сервер с помощью uvicorn приложения из main.py
CMD ["python", "main.py"]
