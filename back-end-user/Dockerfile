# Используем базовый образ python:3.12-alpine
FROM python:3.12-alpine

# Устанавливаем переменные окружения
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Обновляем apk и устанавливаем зависимости
RUN apk update \
    && apk add --no-cache gcc musl-dev libffi-dev postgresql-dev

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы зависимостей в контейнер
COPY requirements.txt .

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем все файлы приложения в контейнер
COPY . .

# Команда для запуска приложения
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
