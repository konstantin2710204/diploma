// src/components/Home.js
import React from 'react';
import Navbar from './Navbar';
import '../styles/Home.css';

const Home = () => {
  return (
    <div className="home">
      <Navbar />
      <div className="hero-section">
        <div className="hero-content">
          <h1>BUILD BOX</h1>
          <p>Лучшие ПК доступны каждому</p>
        </div>
      </div>
      <div className="services-section">
        <div className="service repair">
          <h2>Сломалась техника?</h2>
          <p>Обращайтесь за помощью в Build Box!</p>
          <button>отправить на ремонт</button>
        </div>
        <div className="service custom-pc">
          <h2>Хотите собрать ПК,</h2>
          <p>но не знаете как? Мы соберем его за вас!</p>
          <button>связаться с нами</button>
        </div>
      </div>
      <div className="info-section">
        <div className="info-block">
          <ul>
            <li>опыт в ремонте техники более 10 лет</li>
            <li>использование качественного оборудования и расходных материалов</li>
            <li>квалифицированные мастера</li>
            <li>помещение в центре города</li>
          </ul>
        </div>
        <div className="contact-info">
          <p>Более 1000 отзывов на Яндекс.Картах, 2GIS и Google Maps</p>
          <p>+7 (812) 999-99-99</p>
        </div>
      </div>
    </div>
  );
}

export default Home;
