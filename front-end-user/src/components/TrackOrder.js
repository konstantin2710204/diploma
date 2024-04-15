// src/components/TrackOrder.js
import React, { useState } from 'react';
import '../styles/TrackOrder.css';

const TrackOrder = () => {
  const [orderInfo, setOrderInfo] = useState({
    repairOrderNumber: '',
    repairPhoneNumber: '',
    assemblyOrderNumber: '',
    assemblyPhoneNumber: '',
  });
  const [statusMessage, setStatusMessage] = useState('');

  const handleChange = (e) => {
    setOrderInfo({
      ...orderInfo,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = async (event, orderType) => {
    event.preventDefault();
    // В зависимости от типа заказа (ремонт или сборка) используйте соответствующий endpoint API
    const endpoint = orderType === 'repair' ? 'repair-orders' : 'assembly-orders';
    const orderNumber = orderType === 'repair' ? orderInfo.repairOrderNumber : orderInfo.assemblyOrderNumber;
    const phoneNumber = orderType === 'repair' ? orderInfo.repairPhoneNumber : orderInfo.assemblyPhoneNumber;

    setStatusMessage('Загрузка...'); // Показать сообщение о загрузке

    try {
      const response = await fetch(`http://localhost:8000/api/${endpoint}?orderNumber=${orderNumber}&phone=${phoneNumber}`);
      const data = await response.json();
      setStatusMessage(data.status);
    } catch (error) {
      setStatusMessage('Произошла ошибка при отслеживании заказа. Пожалуйста, попробуйте позже.');
      console.error('Ошибка при отслеживании заказа:', error);
    }
  };

  return (
    <div className="track-order-page">
      <div className="track-order-content">
        <h1>Отслеживание заказа</h1>
        <div className="track-order-forms">
          <div className="track-order-form">
            <h2>Ремонт</h2>
            <form onSubmit={(e) => handleSubmit(e, 'repair')}>
              <input
                type="text"
                name="repairOrderNumber"
                placeholder="Номер заказа"
                value={orderInfo.repairOrderNumber}
                onChange={handleChange}
                required
              />
              <input
                type="tel"
                name="repairPhoneNumber"
                placeholder="Номер телефона"
                value={orderInfo.repairPhoneNumber}
                onChange={handleChange}
                required
              />
              <button type="submit">отследить заказ</button>
            </form>
          </div>
          <div className="track-order-form">
            <h2>Сборки</h2>
            <form onSubmit={(e) => handleSubmit(e, 'assembly')}>
              <input
                type="text"
                name="assemblyOrderNumber"
                placeholder="Номер заказа"
                value={orderInfo.assemblyOrderNumber}
                onChange={handleChange}
                required
              />
              <input
                type="tel"
                name="assemblyPhoneNumber"
                placeholder="Номер телефона"
                value={orderInfo.assemblyPhoneNumber}
                onChange={handleChange}
                required
              />
              <button type="submit">отследить заказ</button>
            </form>
          </div>
        </div>
        <div className="status-message">{statusMessage}</div>
      </div>
    </div>
  );
};

export default TrackOrder;
