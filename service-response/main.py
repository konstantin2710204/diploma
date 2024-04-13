from flask import Flask, render_template
import psycopg2

app = Flask(__name__)

# Настройте параметры соединения с вашей базой данных PostgreSQL
DB_HOST = '172.17.0.3'
DB_NAME = 'repair_shop'
DB_USER = 'postgres'
DB_PASSWORD = 'password'

# Функция для выполнения запросов к базе данных
def execute_query(query, params=None, fetchall=False):
    conn = psycopg2.connect(host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
    cursor = conn.cursor()
    if params:
        cursor.execute(query, params)
    else:
        cursor.execute(query)
    if fetchall:
        result = cursor.fetchall()
    else:
        result = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()
    return result

@app.route('/')
def index():
    # Пример выполнения запроса к базе данных и передачи данных в шаблон
    result = execute_query('SELECT * FROM repair_shop.Devices')
    return render_template('index.html', devices=result)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')