// src/components/TrackOrderResult.js
import React from 'react';
import '../styles/TrackOrderResult.css';

const TrackOrderResult = ({ orderStatus }) => {
  return (
    <div className="track-order-result">
      <h2>Результат отслеживания заказа</h2>
      {orderStatus ? (
        <div className="order-status">
          <p>Статус вашего заказа: <strong>{orderStatus}</strong></p>
        </div>
      ) : (
        <div className="order-status">
          <p>Информация о заказе не найдена. Пожалуйста, убедитесь, что вы ввели правильные данные или свяжитесь с нами для получения помощи.</p>
        </div>
      )}
    </div>
  );
};

export default TrackOrderResult;
