// src/components/Reviews.js
import React from 'react';
import '../styles/Reviews.css';

const reviewsData = [
  {
    name: 'Михаил М.',
    rating: 5,
    text: `Мне довелось воспользоваться услугами Build Box по ремонту ноутбуков, и я остался полностью удовлетворен результатом. Мой ноутбук начал проявлять проблемы, и я решил обратиться за помощью.

После обращения ко мне быстро связались, провели диагностику и предоставили подробную информацию о неисправностях. Оценка стоимости ремонта была честной и прозрачной, без скрытых платежей.

В процессе ремонта мне регулярно сообщали о ходе работ, что добавляло уверенности. Сервисный центр проявил профессионализм и ответственный подход. Когда я забрал свой ноутбук, он был не только полностью исправлен, но и был проведен комплексный технический осмотр, чтобы исключить возможные проблемы в будущем.`
    // Другие данные отзыва по необходимости
  },
  // Дополнительные отзывы можно добавить здесь
];

const Reviews = () => {
  return (
    <div className="reviews">
      {reviewsData.map((review, index) => (
        <div key={index} className="review-card">
          <div className="review-header">
            <h3>{review.name}</h3>
            <div className="rating">{'★'.repeat(review.rating)}</div>
          </div>
          <p className="review-text">{review.text}</p>
        </div>
      ))}
    </div>
  );
}

export default Reviews;
