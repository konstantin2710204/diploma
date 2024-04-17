from flask import Flask
from .config import Config
from .models import db, login_manager
from .views import views

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    login_manager.init_app(app)
    login_manager.login_view = 'views.login'

    app.register_blueprint(views)

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
