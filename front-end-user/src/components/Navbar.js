// src/components/Navbar.js
import React from 'react';

const Navbar = () => {
  return (
    <nav className="navbar">
      <div className="logo">BUILD BOX</div>
      <div className="nav-links">
        <a href="/home">Главная</a>
        <a href="/price-list">Прайс-лист</a>
        <a href="/order-tracking">Отслеживание заказа</a>
        <a href="/reviews">Отзывы</a>
        <a href="/about">О нас</a>
        <a href="/contacts">Контакты</a>
      </div>
    </nav>
  );
}

export default Navbar;
