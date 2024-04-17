from flask import Flask
from .extensions import db, login_manager
from .config import Config
from .views import views
from .models import configure_login_manager

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    login_manager.init_app(app)
    login_manager.login_view = 'views.login'

    app.register_blueprint(views)

    with app.app_context():
        db.create_all()  # Создать таблицы базы данных

    configure_login_manager(login_manager)

    return app
