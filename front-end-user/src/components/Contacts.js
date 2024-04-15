// src/components/Contacts.js
import React from 'react';
import '../styles/Contacts.css';
import mapImage from '../assets/map-placeholder.png'; // Убедитесь, что у вас есть изображение карты в этом месте

const Contacts = () => {
  return (
    <div className="contacts">
      <div className="contact-info">
        <h1>Контакты</h1>
        <p>Свяжитесь с нами уже сегодня и мы примем ваше устройство в работу</p>
        <div className="contact-details">
          <p><strong>Телефон:</strong> +7 (812) 999-99-99</p>
          <p><strong>Адрес:</strong> 10-я Красноармейская, 14</p>
          <p><strong>Часы работы:</strong> Пн-Пт: 10:00 - 21:00, Сб-Вс: 12:00 - 21:00</p>
        </div>
        <div className="social-links">
          {/* Предполагается, что вы будете использовать иконки из некоторой библиотеки иконок, например FontAwesome */}
          <a href="https://vk.com" target="_blank" rel="noopener noreferrer">VK</a>
          <a href="https://telegram.org" target="_blank" rel="noopener noreferrer">Telegram</a>
          <a href="https://twitter.com" target="_blank" rel="noopener noreferrer">Twitter</a>
          <a href="https://youtube.com" target="_blank" rel="noopener noreferrer">YouTube</a>
          {/* Другие социальные сети */}
        </div>
      </div>
      <div className="map">
        <img src={mapImage} alt="Карта с расположением сервисного центра" />
      </div>
    </div>
  );
}

export default Contacts;
