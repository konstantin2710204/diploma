import React, { useState, useEffect } from 'react';

function OrderTracking() {
  const [orderStatus, setOrderStatus] = useState('');

  useEffect(() => {
    // Функция для получения статуса заказа по API
    const fetchOrderStatus = async () => {
      const response = await fetch('http://localhost:8000/orders/'); // URL бэкенда FastAPI
      const data = await response.json();
      setOrderStatus(data.status); // Пример поля статуса
    };

    fetchOrderStatus();
  }, []);

  return (
    <div>
      <h1>Track Your Order</h1>
      <p>Status: {orderStatus}</p>
    </div>
  );
}

export default OrderTracking;
