# Используем официальный образ Python как базовый
FROM python:3.9-slim

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Копируем файлы зависимостей в рабочую директорию
COPY requirements.txt .

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем остальные файлы проекта в рабочую директорию
COPY . .

# Задаем переменную окружения для базы данных, необходимо настроить для продуктивной среды
ENV DATABASE_URL=postgresql://postgres:password@172.17.0.2/repair_shop

# Открываем порт 8000 для внешнего мира
EXPOSE 8000

# Запускаем приложение
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
