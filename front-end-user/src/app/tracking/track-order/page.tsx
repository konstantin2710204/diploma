'use client'

import { useState } from 'react';
import { useRouter } from 'next/navigation';

const TrackingOrderPage = () => {
  const [repairOrder, setRepairOrder] = useState({ orderId: '' });
  const [buildOrder, setBuildOrder] = useState({ orderId: '' });
  const router = useRouter();

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>, setOrder: Function) => {
    const { name, value } = event.target;
    setOrder((prevState: any) => ({ ...prevState, [name]: value }));
  };

  const trackOrder = async (event: React.FormEvent, type: string) => {
    event.preventDefault();
    const orderId = type === 'repair' ? repairOrder.orderId : buildOrder.orderId;
    const apiUrl = type === 'repair' 
      ? `${process.env.NEXT_PUBLIC_API_URL}/api/track-order/${orderId}`
      : `${process.env.NEXT_PUBLIC_API_URL}/api/track-order/build/${orderId}`;

    try {
      const response = await fetch(apiUrl);
      if (response.ok) {
        const data = await response.json();
        const route = type === 'repair' 
          ? `/tracking/track-order/${orderId}` 
          : `/tracking/track-order/build/${orderId}`;
        router.push(route);
      } else {
        alert('Заказ с такими данными не найден');
        resetOrderFields(type);
      }
    } catch (error) {
      console.error('Error fetching order data:', error);
      alert('Произошла ошибка при запросе данных заказа');
      resetOrderFields(type);
    }
  };

  const resetOrderFields = (type: string) => {
    if (type === 'repair') {
      setRepairOrder({ orderId: '' });
    } else {
      setBuildOrder({ orderId: '' });
    }
  };

  const handleKeyPress = (event: React.KeyboardEvent<HTMLInputElement>) => {
    const charCode = event.charCode;
    if (charCode < 48 || charCode > 57) {
      event.preventDefault();
    }
  };

  return (
    <section id="tracking-order" className="bg-obsidian text-white p-4 md:p-10 min-h-screen">
      <div className="max-w-screen-lg mx-auto">
        <h2 className="lg:text-h2 text-h2m my-8 md:my-16 text-center">Отслеживание заказа</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-8">
          <div className="bg-gray p-4 md:p-6 rounded-2xl">
            <h3 className="text-h2m lg:text-h2 mb-4">Ремонт</h3>
            <form onSubmit={(event) => trackOrder(event, 'repair')}>
              <input
                type="text"
                name="orderId"
                value={repairOrder.orderId}
                onChange={(event) => handleInputChange(event, setRepairOrder)}
                onKeyPress={handleKeyPress}
                placeholder="Номер заказа"
                className="w-full p-2 md:p-3 mb-4 rounded-lg bg-obsidian text-white"
              />
              <button className="bg-white text-gunmetal text-pm lg:text-p px-4 py-2 md:px-6 md:py-3 rounded-xl mt-4" type="submit">
                отследить заказ
              </button>
            </form>
          </div>
          <div className="bg-gray p-4 md:p-6 rounded-2xl">
            <h3 className="text-h2m lg:text-h2 mb-4">Сборки</h3>
            <form onSubmit={(event) => trackOrder(event, 'build')}>
              <input
                type="text"
                name="orderId"
                value={buildOrder.orderId}
                onChange={(event) => handleInputChange(event, setBuildOrder)}
                onKeyPress={handleKeyPress}
                placeholder="Номер заказа"
                className="w-full p-2 md:p-3 mb-4 rounded-lg bg-obsidian text-white"
              />
              <button className="bg-purple text-white text-pm lg:text-p px-4 py-2 md:px-6 md:py-3 rounded-xl mt-4" type="submit">
                отследить заказ
              </button>
            </form>
          </div>
        </div>
      </div>
    </section>
  );
};

export default TrackingOrderPage;
