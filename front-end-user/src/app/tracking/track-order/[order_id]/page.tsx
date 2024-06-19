'use client'

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import axios from 'axios';

const OrderDetailsPage = () => {
  const [order, setOrder] = useState(null);
  const [error, setError] = useState(null);
  const params = useParams();
  const router = useRouter();
  const { order_id } = params;

  useEffect(() => {
    if (!order_id) return;

    const fetchOrderDetails = async () => {
      try {
        console.log(`Fetching order details for order_id: ${order_id}`);
        const response = await axios.get(`${process.env.NEXT_PUBLIC_API_URL}/api/track-order/${order_id}`, {
          headers: {
            'Content-Type': 'application/json'
          }
        });
        setOrder(response.data);
        console.log('Order data received:', response.data);
      } catch (err) {
        console.error('Error fetching order details:', err);
        setError(err.message);
      }
    };

    fetchOrderDetails();
  }, [order_id]);

  if (error) {
    return (
      <section className="bg-obsidian text-white p-10 min-h-screen flex items-center justify-center">
        <div className="bg-gunmetal p-6 rounded-2xl">
          <h2 className="text-h2 mb-4">Ошибка</h2>
          <p className="text-p mb-4">{error}</p>
          <button className="bg-white text-gunmetal text-p px-6 py-3 rounded-xl mt-4" onClick={() => router.back()}>
            Назад
          </button>
        </div>
      </section>
    );
  }

  if (!order) {
    return (
      <section className="bg-obsidian text-white p-10 min-h-screen flex items-center justify-center">
        <div className="text-p">Загрузка...</div>
      </section>
    );
  }

  return (
    <section className="bg-obsidian text-white p-10 min-h-screen">
      <div className="max-w-screen-md mx-auto">
        <h2 className="text-h2 mb-8 text-center mt-32">Заказ #{order_id}</h2>
        <div className="bg-gray p-6 rounded-2xl">
          <p className="text-p mb-4"><strong>Устройство:</strong> {order.device_model}</p>
          <p className="text-p mb-4"><strong>Статус:</strong> {order.status}</p>
          <p className="text-p mb-4"><strong>Номер телефона:</strong> {order.client_phone_number}</p>
          <p className="text-p mb-4"><strong>Ответственный инженер:</strong> {order.engineer_name}</p>
        </div>
      </div>
    </section>
  );
};

export default OrderDetailsPage;
