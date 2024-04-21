from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, IntegerField, SelectField, DecimalField, TextAreaField, DateField
from wtforms.validators import DataRequired, Length, ValidationError, NumberRange
from .models import Employee  # Импортируем модель сотрудников для проверки логина

class LoginForm(FlaskForm):
    username = StringField('Имя пользователя', validators=[DataRequired(), Length(min=3, max=50)])
    password = PasswordField('Пароль', validators=[DataRequired()])
    submit = SubmitField('Войти')

    def validate_username(self, username):
        user = Employee.query.filter_by(login=username.data).first()
        if not user:
            raise ValidationError('Нет аккаунта с таким именем пользователя.')

class OrderForm(FlaskForm):
    client_id = IntegerField('Client ID', validators=[DataRequired()])
    device_id = IntegerField('Device ID', validators=[DataRequired()])
    status = SelectField('Status', choices=[('создан', 'Создан'), ('в работе', 'В работе'), ('готов к выдаче', 'Готов к выдаче'), ('завершен', 'Завершен')], validators=[DataRequired()])
    engineer_id = IntegerField('Engineer ID', validators=[DataRequired()])
    creation_date = DateField('Creation Date', format='%Y-%m-%d', validators=[DataRequired()])
    cost = DecimalField('Cost', validators=[DataRequired(), NumberRange(min=0)])
    submit = SubmitField('Submit')

class BuildForm(FlaskForm):
    engineer_id = IntegerField('Engineer ID', validators=[DataRequired()])
    client_id = IntegerField('Client ID', validators=[DataRequired()])
    components = TextAreaField('Components', validators=[DataRequired()])
    components_cost = DecimalField('Components Cost', validators=[DataRequired(), NumberRange(min=0)])
    service_fee = DecimalField('Service Fee', validators=[DataRequired(), NumberRange(min=0)])
    creation_date = DateField('Creation Date', format='%Y-%m-%d', validators=[DataRequired()])
    status = SelectField('Status', choices=[('создан', 'Создан'), ('в работе', 'В работе'), ('готов к выдаче', 'Готов к выдаче'), ('завершен', 'Завершен')], validators=[DataRequired()])
    submit = SubmitField('Submit')
