from flask import Flask, Blueprint, request, render_template, redirect, url_for, flash, session, current_app
from .models import db, Employee, Order, ComputerBuild, ArchivedOrder, ArchivedComputerBuild, Client, Device, CallbackOrder, CallbackComputerBuild
from .forms import LoginForm, OrderForm, BuildForm

main = Blueprint('main', __name__)

@main.route('/')
def index():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    # Определите роль пользователя и покажите соответствующую дашборду
    user = Employee.query.get(session['user_id'])
    if user.role == 'engineer':
        orders = Order.query.filter_by(engineer_id=user.employee_id).all()
        builds = ComputerBuild.query.filter_by(engineer_id=user.employee_id).all()
        return render_template('dashboard_engineer.html', user=user, orders=orders, builds=builds)
    elif user.role == 'receptionist':
        orders = Order.query.all()
        builds = ComputerBuild.query.all()
        return render_template('dashboard_receptionist.html', user=user, orders=orders, builds=builds)
    else:
        orders = Order.query.all()
        builds = ComputerBuild.query.all()
        archived_orders = ArchivedOrder.query.all()
        archived_builds = ArchivedComputerBuild.query.all()
        return render_template('dashboard.html', user=user, orders=orders, builds=builds, archived_orders=archived_orders, archived_builds=archived_builds)  # Для админа или других ролей

@main.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm(request.form)
    if form.validate_on_submit():
        user = Employee.query.filter_by(login=form.username.data).first()
        if user and current_app.bcrypt.check_password_hash(user.password.hashed_password, form.password.data):
            session['user_id'] = user.employee_id
            return redirect(url_for('main.index'))
        flash('Invalid username or password')
    return render_template('login.html', form=form)

@main.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('main.login'))

@main.route('/orders', methods=['GET', 'POST'])
def orders():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role == 'receptionist' or user.role == 'service_owner':
        orders = Order.query.all()
    else:
        orders = Order.query.filter_by(engineer_id=user.employee_id).all()
    return render_template('order_list.html', orders=orders)

@main.route('/create_order', methods=['POST'])
def create_order():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role == 'receptionist' or user.role == 'service_owner':
        client_name = request.form['client_name']
        client_phone = request.form['client_phone']
        device_type = request.form['type']
        model = request.form['model']
        serial_number = request.form['serial_number']

        # Создание нового клиента (пример, если клиенты не хранятся в базе)
        new_client = Client(name=client_name, contact_info=client_phone)
        db.session.add(new_client)
        db.session.commit()

        # Создание нового заказа
        new_order = Order(client_id=new_client.id, type=device_type, model=model, serial_number=serial_number, status='создан')
        db.session.add(new_order)
        db.session.commit()

        flash('Новый заказ создан успешно!')
        return redirect(url_for('main.orders'))

@main.route('/order/<int:order_id>/update_status', methods=['GET', 'POST'])
def update_order_status(order_id):
    order = Order.query.get_or_404(order_id)
    form = OrderForm(obj=order)
    if form.validate_on_submit():
        form.populate_obj(order)
        db.session.commit()
        return redirect(url_for('main.orders'))
    return render_template('edit_order.html', form=form, order=order)

@main.route('/builds')
def builds():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role == 'receptionist' or user.role == 'service_owner':
        builds = ComputerBuild.query.all()
    else:
        builds = ComputerBuild.query.filter_by(engineer_id=user.employee_id).all()
    return render_template('build_list.html', builds=builds)

@main.route('/create_build', methods=['POST'])
def create_build():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role == 'receptionist' or user.role == 'service_owner':
        client_name = request.form['client_name']
        client_phone = request.form['client_phone']
        budget = request.form['budget']
        preferences = request.form['preferences']

        # Создание нового клиента (пример, если клиенты не хранятся в базе)
        new_client = Client(name=client_name, contact_info=client_phone)
        db.session.add(new_client)
        db.session.commit()

        # Создание новой сборки
        new_build = ComputerBuild(client_id=new_client.id, budget=budget, build_preferences=preferences, status='создан')
        db.session.add(new_build)
        db.session.commit()

        flash('Новый заказ создан успешно!')
    else:
        return redirect(url_for('main.login'))
    return redirect(url_for('main.builds'))

@main.route('/build/<int:build_id>/update_status', methods=['GET', 'POST'])
def update_build_status(build_id):
    build = ComputerBuild.query.get_or_404(build_id)
    form = BuildForm(obj=build)
    if form.validate_on_submit():
        form.populate_obj(build)
        db.session.commit()
        return redirect(url_for('main.builds'))
    return render_template('edit_build.html', form=form, build=build)

@main.route('/archive')
def archive():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role == 'receptionist' or user.role == 'service_owner':
        archived_orders = ArchivedOrder.query.all()
        archived_builds = ArchivedComputerBuild.query.all()
    return render_template('archive.html', archived_orders=archived_orders, archived_builds=archived_builds)


if __name__ == '__main__':
    app.run(debug=True)
