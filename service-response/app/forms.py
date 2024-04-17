from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField
from wtforms.validators import DataRequired

class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')

class OrderForm(FlaskForm):
    status = SelectField('Status', choices=[('created', 'Создан'), ('in_progress', 'В работе'), ('ready_to_pick_up', 'Готов к выдаче'), ('completed', 'Завершен')])
    submit = SubmitField('Update Status')
