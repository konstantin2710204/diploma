from flask import Blueprint, render_template, redirect, url_for, request, flash
from flask_login import login_user, logout_user, login_required, current_user
from .models import User, Order
from .extensions import db

views = Blueprint('views', __name__)

@views.route('/')
@login_required
def home():
    return redirect(url_for('views.view_orders'))

@views.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User.query.filter_by(username=username).first()
        if user and user.check_password(password):
            login_user(user)
            next_page = request.args.get('next')
            return redirect(next_page or url_for('views.home'))
        flash('Invalid username or password')
    return render_template('login.html')

@views.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('views.login'))

@views.route('/orders')
@login_required
def view_orders():
    orders = Order.query.all()
    return render_template('orders.html', orders=orders)

@views.route('/orders/<int:order_id>', methods=['GET', 'POST'])
@login_required
def edit_order(order_id):
    order = Order.query.get_or_404(order_id)
    if request.method == 'POST':
        order.status = request.form['status']
        db.session.commit()
        return redirect(url_for('views.view_orders'))
    return render_template('order_edit.html', order=order)

@views.app_errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404
