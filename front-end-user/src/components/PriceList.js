import React, { useEffect, useState } from 'react';

function PriceList() {
  const [prices, setPrices] = useState([]);

  useEffect(() => {
    fetch('http://localhost:8000/prices')
      .then(response => response.json())
      .then(data => setPrices(data))
      .catch(error => console.error('Failed to load prices', error));
  }, []);

  return (
    <section id="price-list">
      <h2>Прайс-лист</h2>
      <ul>
        {prices.map(price => (
          <li key={price.id}>{price.service}: {price.cost} руб.</li>
        ))}
      </ul>
    </section>
  );
}

export default PriceList;
