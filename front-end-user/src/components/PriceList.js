// src/components/PriceList.js
import React from 'react';
import '../styles/PriceList.css';

const PriceList = () => {
  return (
    <div className="price-list">
      <div className="price-list-header">
        <h1>Прайс-лист</h1>
      </div>
      <div className="price-list-content">
        <ServiceCategory title="Видеокарты" services={graphicsCardsServices} />
        <ServiceCategory title="Ноутбуки" services={laptopServices} />
        <ServiceCategory title="Прочие услуги" services={otherServices} />
      </div>
    </div>
  );
}

const ServiceCategory = ({ title, services }) => {
  return (
    <div className="service-category">
      <h2>{title}</h2>
      {services.map((serviceGroup, index) => (
        <div className="service-group" key={index}>
          <h3>{serviceGroup.name}</h3>
          <ul>
            {serviceGroup.items.map((item, itemIndex) => (
              <li key={itemIndex}>
                <span>{item.name}</span>
                <span>{item.price}</span>
              </li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}

const graphicsCardsServices = [    
  {
    name: "Ремонт видеокарт AMD",
    items: [
      { name: 'RX 5700 XT', price: 'от 3 000₽' },
      { name: 'RX 6600 / 6600 XT', price: 'от 3 000₽' },
      { name: 'RX 6700 / 6700 XT', price: 'от 3 500₽' },
      { name: 'RX 6800 / 6800 XT', price: 'от 4 000₽' },
      { name: 'RX 6900 / 6900 XT', price: 'от 4 000₽' },
      { name: 'RX 7700 XT / 7800 XT', price: 'от 4 000₽' },
      { name: 'RX 7900 XT / 7900 XTX', price: 'от 6 000₽' }
    ]
  },
  {
    name: "Ремонт видеокарт NVIDIA",
    items: [
      { name: 'GTX 1660 SUPER / TI', price: 'от 3 000₽' },
      { name: 'RTX 3060 / 3060 TI', price: 'от 3 500₽' },
      { name: 'RTX 3070 / 3070 TI', price: 'от 4 000₽' },
      { name: 'RTX 3080 TI / 3090', price: 'от 5 000₽' },
      { name: 'RTX 4070 TI / 4080', price: 'от 6 000₽' },
      { name: 'RTX 4080 TI / 4090', price: 'от 8 000₽' }
    ]
  },
];

const laptopServices = [
  {
    name: "Ремонт",
    items: [
      { name: 'Замена чипсета', price: 'от 3 000₽' },
      { name: 'Замена разъёма', price: 'от 3 000₽' },
      { name: 'Замена CPU', price: 'от 3 500₽' },
      { name: 'Замена GPU', price: 'от 4 000₽' },
      { name: 'Замена видеопамяти', price: 'от 4 000₽' }
    ]
  },
  {
    name: "Обслуживание",
    items: [
      { name: 'Обслуживание ноутбуков', price: 'от 3 000₽' },
    ]
  },
];

const otherServices = [
  {
      name: "Дополнительные услуги",
      items: [
          { name: 'Диагностика', price: '1 500₽' },
          { name: 'Обслуживание компьютеров', price: 'от 2 000₽' },
          { name: 'Сборка компьютеров на заказ', price: 'договорная' }
      ]
  }
];

export default PriceList;
