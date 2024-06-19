'use client'

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

const questions = [
  {
    question: 'Какую технику вы ремонтируете?',
    answer: 'Мы ремонтируем ноутбуки, видеокарты, системные блоки и материнские платы',
  },
  {
    question: 'Сколько времени занимает диагностика?',
    answer: 'Диагностика занимает от 1 до 3 рабочих дней в зависимости от сложности проблемы',
  },
  {
    question: 'Сколько времени занимает ремонт?',
    answer: 'Ремонт занимает от 3 до 14 рабочих дней в зависимости от наличия запчастей и сложности проблемы',
  },
  {
    question: 'Есть гарантия на ремонт?',
    answer: 'Да, мы предоставляем гарантию на выполненные работы сроком на 1 месяц',
  },
  {
    question: 'С техникой после ремонта что-то не так',
    answer: 'Если у вас возникли проблемы с техникой после ремонта, свяжитесь с нами, и мы устраним неисправности в рамках гарантийного периода',
  },
  {
    question: 'Могу ли я протестировать устройство до оплаты?',
    answer: 'Да, вы можете протестировать устройство до оплаты, чтобы убедиться в его исправности',
  },
];

const Questions = () => {
  const [activeIndex, setActiveIndex] = useState<number | null>(null);

  const toggleQuestion = (index: number) => {
    setActiveIndex(activeIndex === index ? null : index);
  };

  return (
    <section id="questions" className="bg-obsidian text-white p-10">
      <div className="max-w-screen-md mx-auto">
        <h2 className="text-h2m lg:text-h2 mb-8 text-center">Вопросы</h2>
        <div className="space-y-4 mb-12">
          {questions.map((item, index) => (
            <div key={index} className="pb-2">
              <div
                className="flex justify-between items-center cursor-pointer"
                onClick={() => toggleQuestion(index)}
              >
                <span className="text-pm lg:text-p">{item.question}</span>
                <motion.span
                  className="text-h1m text-2xl ml-6 lg:text-h1"
                  animate={{ rotate: activeIndex === index ? 45 : 0 }}
                  transition={{ duration: 0.3 }}
                >
                  +
                </motion.span>
              </div>
              <AnimatePresence initial={false}>
              {activeIndex === index && (
                <motion.div
                  className="pt-2"
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: 'auto', opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ height: { duration: 0.3 }, opacity: { duration: 0.3 } }}
                >
                  <motion.p className="text-p mx-6" initial={{ opacity: 0}} animate={{ opacity: 1}} exit={{ opacity: 0 }}>
                    <p className="text-pm lg:text-p mt-3">{item.answer}</p>
                  </motion.p>
                </motion.div>
              )}
              </AnimatePresence>
            </div>
          ))}
        </div>
        <div className="text-center">
          <h3 className="text-h3m lg:text-h3 mb-4">Не нашли ответа на свой вопрос?</h3>
          <p className="text-pm lg:text-p mb-4">Свяжитесь с нами, ответим как можно скорее</p>
          <div className="flex justify-center space-x-4 mb-4">
            <a href="https://vk.com/buildbox_spb" target="_blank" rel="noopener noreferrer">
              <img src="/vkontakteWhite.svg" alt="VK" className="w-8 h-8" />
            </a>
            <a href="https://telegram.org" target="_blank" rel="noopener noreferrer">
              <img src="/telegramWhite.svg" alt="Telegram" className="w-8 h-8" />
            </a>
            <a href="https://whatsapp.com" target="_blank" rel="noopener noreferrer">
              <img src="/whatsappWhite.svg" alt="WhatsApp" className="w-8 h-8" />
            </a>
          </div>
          <p className="text-p mb-10">+7 (812) 999-99-99</p>
        </div>
      </div>
    </section>
  );
};

export default Questions;
