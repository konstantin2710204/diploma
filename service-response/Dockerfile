# Используем официальный образ Python как базовый
FROM python:3.12-alpine

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Копируем файл зависимостей в рабочую директорию
COPY requirements.txt .

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем остальные файлы проекта в рабочую директорию
COPY . .

# Объявляем переменные окружения
ENV FLASK_APP=run.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=development

# Открываем порт, который будет слушать сервер Flask
EXPOSE 5000

# Запускаем приложение Flask при старте контейнера
CMD ["flask", "run"]
