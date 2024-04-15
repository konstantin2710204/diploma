// src/components/Footer.js
import React from 'react';
import '../styles/Footer.css';

const Footer = () => {
  return (
    <footer className="footer">
      <div className="footer-navigation">
        <ul className="footer-links">
          <li><a href="/">Главная</a></li>
          <li><a href="/price-list">Прайс-лист</a></li>
          <li><a href="/reviews">Отзывы</a></li>
          <li><a href="/about">О нас</a></li>
          <li><a href="/contacts">Контакты</a></li>
        </ul>
        <ul className="footer-links">
          <li><a href="/privacy">Политика конфиденциальности</a></li>
          <li><a href="/ads">Аферта</a></li>
          <li><a href="/vacancies">Вакансии</a></li>
          <li><a href="/corporate">Корпоративным клиентам</a></li>
          <li><a href="/individuals">Юридическим лицам</a></li>
        </ul>
      </div>
      <div className="footer-contacts">
        <div className="footer-phone">
          <a href="tel:+78129999999">+7 (812) 999-99-99</a>
        </div>
        <div className="footer-social">
          {/* Ссылки на социальные сети */}
        </div>
        <div className="footer-email">
          <a href="mailto:build_box@mail.ru">build_box@mail.ru</a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
