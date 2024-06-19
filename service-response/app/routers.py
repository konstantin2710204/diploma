from flask import Blueprint, request, render_template, redirect, url_for, flash, session, current_app
from .models import db, Employee, Order, ComputerBuild, ArchivedOrder, ArchivedComputerBuild, Client, Device, CallbackOrder, CallbackComputerBuild
from .forms import LoginForm, OrderForm, BuildForm

main = Blueprint('main', __name__)

@main.route('/')
def index():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    # Определите роль пользователя и покажите соответствующую дашборду
    user = Employee.query.get(session['user_id'])
    if user.role.name == 'Инженер':
        orders = Order.query.filter_by(engineer_id=user.employee_id).all()
        builds = ComputerBuild.query.filter_by(engineer_id=user.employee_id).all()
        return render_template('dashboard_engineer.html', user=user, orders=orders, builds=builds)
    elif user.role.name == 'Приемщик':
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
        else:
            flash('Неправильный логин или пароль', 'error')
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
    if user.role.name == 'Приемщик' or user.role.name == 'Владелец':
        orders = Order.query.all()
    else:
        orders = Order.query.filter_by(engineer_id=user.employee_id).all()
    return render_template('order_list.html', orders=orders)

@main.route('/create_order', methods=['GET','POST'])
def create_order():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    
    if request.method == 'POST':
        client_name = request.form['client_name']
        client_phone = request.form['client_phone']
        device_type = request.form['type']
        device_model = request.form['model']
        device_defect = request.form['defect']
        device_serial_number = request.form['serial_number']
        
        # Проверка существования клиента
        existing_client = Client.query.filter_by(phone_number=client_phone).first()
        
        if existing_client:
            client_id = existing_client.client_id
        else:
            # Создание нового клиента
            new_client = Client(
                name=client_name,
                phone_number=client_phone
            )
            db.session.add(new_client)
            db.session.commit()
            client_id = new_client.client_id
        
        # Добавление устройства
        new_device = Device(
            client_id=client_id,
            type=device_type,
            model=device_model,
            serial_number=device_serial_number
        )

        db.session.add(new_device)
        db.session.commit()
        device_id = new_device.device_id
        
        # Создание нового заказа
        new_order = Order(
            client_id=client_id,
            device_id=device_id, 
            defect=device_defect,
            status='Создан'
        )
        db.session.add(new_order)
        db.session.commit()
        
        flash('Заказ успешно создан')
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

@main.route('/update_order_cost/<int:order_id>', methods=['GET', 'POST'])
def update_order_cost(order_id):
    order = Order.query.get_or_404(order_id)
    new_cost = request.form['cost']
    if new_cost:
        try:
            order.cost = float(new_cost)
            db.session.commit()
            flash('Цена успешно обновлена', 'success')
        except ValueError:
            flash('Некорректное значение цены', 'danger')
    else:
        flash('Цена не может быть пустой', 'danger')
    return redirect(url_for('main.orders'))


@main.route('/delete_callback_order/<int:id>', methods=['GET', 'POST'])
def delete_callback_order(id):
    callback_order = CallbackOrder.query.get_or_404(id)
    db.session.delete(callback_order)
    db.session.commit()
    return redirect(url_for('main.callback_orders'))

@main.route('/builds')
def builds():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role.name == 'Приемщик' or user.role.name == 'Владелец':
        builds = ComputerBuild.query.all()
    else:
        builds = ComputerBuild.query.filter_by(engineer_id=user.employee_id).all()
    return render_template('build_list.html', builds=builds)

@main.route('/create_build', methods=['POST'])
def create_build():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role.name == 'Приемщик' or user.role.name == 'Владелец':
        client_name = request.form['client_name']
        client_phone = request.form['client_phone']
        components_cost = request.form['components_cost']

        # Проверка существования клиента
        existing_client = Client.query.filter_by(phone_number=client_phone).first()
        
        if existing_client:
            client_id = existing_client.client_id
        else:
            # Создание нового клиента
            new_client = Client(
                name=client_name,
                phone_number=client_phone
            )
            db.session.add(new_client)
            db.session.commit()
            client_id = new_client.client_id

        # Создание новой сборки
        new_build = ComputerBuild(client_id=client_id, components_cost=components_cost, status='Создан')
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

@main.route('/delete_callback_build/<int:id>', methods=['GET', 'POST'])
def delete_callback_build(id):
    callback_build = CallbackComputerBuild.query.get_or_404(id)
    db.session.delete(callback_build)
    db.session.commit()
    return redirect(url_for('main.callback_orders'))

@main.route('/archive')
def archive():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role.name == 'Приемщик' or user.role.name == 'Владелец':
        archived_orders = ArchivedOrder.query.all()
        archived_builds = ArchivedComputerBuild.query.all()
    return render_template('archive.html', archived_orders=archived_orders, archived_builds=archived_builds)

@main.route('/callbacks')
def callback_orders():
    if 'user_id' not in session:
        return redirect(url_for('main.login'))
    user = Employee.query.get(session['user_id'])
    if user.role.name == 'Приемщик' or user.role.name == 'Владелец':
        callback_orders = CallbackOrder.query.all()
        callback_builds = CallbackComputerBuild.query.all()
    return render_template('callback_orders.html', callback_orders=callback_orders, callback_builds=callback_builds)

if __name__ == '__main__':
    app.run(debug=True)
