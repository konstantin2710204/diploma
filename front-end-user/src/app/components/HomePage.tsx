'use client'

import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import InputMask from 'react-input-mask';
import axios from 'axios';

const HomePage = () => {
  const [isRepairModalOpen, setRepairModalOpen] = useState(false);
  const [isContactModalOpen, setContactModalOpen] = useState(false);
  const [budget, setBudget] = useState('');
  const [name, setName] = useState('');
  const [contactName, setContactName] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [model, setModel] = useState('');
  const [defect, setDefect] = useState('');
  const [usageTasks, setUsageTasks] = useState('');
  const [buildPreferences, setBuildPreferences] = useState('');

  const toggleRepairModal = () => {
    setRepairModalOpen(!isRepairModalOpen);
  };

  const toggleContactModal = () => {
    setContactModalOpen(!isContactModalOpen);
  };

  const closeModalOnOutsideClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget) {
      setRepairModalOpen(false);
      setContactModalOpen(false);
    }
  };

  const handleBudgetChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/\D/g, ''); // Удаляет все нецифровые символы
    setBudget(value);
  };

  const handleNameChange = (e: React.ChangeEvent<HTMLInputElement>, setName: React.Dispatch<React.SetStateAction<string>>) => {
    const value = e.target.value.replace(/[0-9]/g, ''); // Удаляет все цифры
    setName(value);
  };

  const handlePhoneNumberChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setPhoneNumber(e.target.value);
  };

  const handleModelChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setModel(e.target.value);
  };

  const handleDefectChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setDefect(e.target.value);
  };

  const handleUsageTasksChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setUsageTasks(e.target.value);
  };

  const handleBuildPreferencesChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setBuildPreferences(e.target.value);
  };

  const formatPhoneNumber = (phone: string) => {
    return phone.replace(/\D/g, ''); // Удаляет все нецифровые символы
  };

  const handleSubmitRepairForm = async (e: React.FormEvent) => {
    e.preventDefault();
    const formattedPhoneNumber = formatPhoneNumber(phoneNumber);
    try {
      await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/api/create-callback-order`, {
        name,
        phone_number: formattedPhoneNumber,
        model,
        defect
      }, {
        headers: {
          'Content-Type': 'application/json'
        }
      });
      setRepairModalOpen(false);
    } catch (error) {
      console.error('Ошибка при отправке формы ремонта:', error);
    }
  };

  const handleSubmitContactForm = async (e: React.FormEvent) => {
    e.preventDefault();
    const formattedPhoneNumber = formatPhoneNumber(phoneNumber);
    try {
      await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/api/create-callback-build`, {
        name: contactName,
        phone_number: formattedPhoneNumber,
        budget: parseInt(budget, 10),
        usage_tasks: usageTasks,
        build_preferences: buildPreferences
      }, {
        headers: {
          'Content-Type': 'application/json'
        }
      });
      setContactModalOpen(false);
    } catch (error) {
      console.error('Ошибка при отправке формы сборки ПК:', error);
    }
  };

  return (
    <section id="home" className="bg-obsidian text-white p-10">
      <div className="max-w-screen-lg mx-auto">
        <div className="flex justify-between items-center mb-10">
          <img src="/logo.svg" alt="BUILD BOX Logo" className="mr-4" />
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="bg-gunmetal p-6 rounded-2xl">
            <h2 className="text-h2m lg:text-h2 mb-4">Сломалась техника? Обращайтесь за помощью в Build Box!</h2>
            <p className="text-pm lg:text-p mb-4">Диагностика в течение <br />3-х рабочих дней</p>
            <button 
              className="bg-white text-gunmetal text-pm lg:text-p px-6 py-3 rounded-xl mt-4"
              onClick={toggleRepairModal}
            >
              отправить на ремонт
            </button>
          </div>
          <div className="bg-white text-gunmetal p-6 rounded-2xl">
            <h2 className="text-h2м lg:text-h2 mb-4">Хотите собрать ПК, но не знаете как? Мы соберем его за вас!</h2>
            <p className="text-pm lg:text-p mb-4">Наши специалисты подберут наиболее оптимальное решение для ваших задач</p>
            <button 
              className="bg-purple text-white text-pm lg:text-p px-9 py-3 rounded-xl mt-4"
              onClick={toggleContactModal}
            >
              связаться с нами
            </button>
          </div>
          <div className="rounded-md">
            <div className="w-full h-full bg-cover bg-center rounded-2xl" style={{ backgroundImage: 'url(/technician.svg)' }}></div>
          </div>
          <div className="bg-gunmetal p-6 rounded-2xl flex-col justify-between">
            <div className="mb-4">
              <ul className="text-pm lg:text-p space-y-2">
                <li> - опыт в ремонте техники более 10 лет</li>
                <li> - использование качественного оборудования и расходных материалов</li>
                <li> - квалифицированные мастера</li>
                <li> - помещение в центре города</li>
                <li> - более 1000 отзывов на Яндекс.Картах, 2ГИС и Google Maps</li>
              </ul>
            </div>
            <div className="bg-white text-gunmetal text-left mt-6 rounded-xl w-auto inline-block">
              <p className="text-pm lg:text-p px-9 py-3">+7 (812) 999-99-99</p>
            </div>
          </div>
        </div>
      </div>

      <AnimatePresence>
        {isRepairModalOpen && (
          <motion.div 
            className="fixed inset-0 flex items-center justify-center z-50 bg-black bg-opacity-50"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={closeModalOnOutsideClick}
          >
            <motion.div 
              className="bg-white text-gunmetal p-10 rounded-lg relative w-11/12 max-w-md"
              initial={{ scale: 0.8 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0.8 }}
            >
              <button 
                className="absolute top-4 right-4 text-gunmetal text-6xl lg:text-7xl"
                onClick={toggleRepairModal}
              >
                &times;
              </button>
              <h2 className="text-h2м lg:text-h2 mb-4">Оставить заявку</h2>
              <p className="text-pm lg:text-p mb-4">Заполните форму для обратной связи</p>
              <form onSubmit={handleSubmitRepairForm}>
                <input 
                  type="text" 
                  placeholder="Имя" 
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal text-pm lg:text-p" 
                  value={name} 
                  onChange={(e) => handleNameChange(e, setName)} 
                />
                <InputMask
                  mask="8 (999) 999-99-99"
                  maskChar=" "
                  placeholder="Номер телефона"
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal text-pm lg:text-p"
                  value={phoneNumber}
                  onChange={handlePhoneNumberChange}
                />
                <input 
                  type="text" 
                  placeholder="Модель" 
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal text-pm lg:text-p"
                  value={model}
                  onChange={handleModelChange}
                />
                <input 
                  type="text" 
                  placeholder="Дефект" 
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal text-pm lg:text-p"
                  value={defect}
                  onChange={handleDefectChange}
                />
                <button className="bg-obsidian text-white text-pm lg:text-p px-4 py-4 rounded-xl w-full">оставить заявку</button>
              </form>
            </motion.div>
          </motion.div>
        )}

        {isContactModalOpen && (
          <motion.div 
            className="fixed inset-0 flex items-center justify-center z-50 bg-black bg-opacity-50"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={closeModalOnOutsideClick}
          >
            <motion.div 
              className="bg-white text-gunmetal p-10 rounded-lg relative w-11/12 max-w-md"
              initial={{ scale: 0.8 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0.8 }}
            >
              <button 
                className="absolute top-4 right-4 text-gunmetal text-6xl lg:text-7xl"
                onClick={toggleContactModal}
              >
                &times;
              </button>
              <h2 className="text-h2м lg:text-h2 mb-4">Оставить заявку</h2>
              <p className="text-pm lg:text-p mb-4">Заpолните форму для обратной связи</p>
              <form onSubmit={handleSubmitContactForm}>
                <input 
                  type="text" 
                  placeholder="Имя" 
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal" 
                  value={contactName} 
                  onChange={(e) => handleNameChange(e, setContactName)} 
                />
                <InputMask
                  mask="8 (999) 999-99-99"
                  maskChar=" "
                  placeholder="Номер телефона"
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal"
                  value={phoneNumber}
                  onChange={handlePhoneNumberChange}
                />
                <div className="relative mb-4">
                  <input 
                    type="text" 
                    placeholder="Бюджет на сборку" 
                    className="w-full p-3 rounded-lg bg-[#d3dbdc] text-gunmetal" 
                    value={budget} 
                    onChange={handleBudgetChange} 
                  />
                  {budget && <span className="absolute right-4 top-3 text-gunmetal">₽</span>}
                </div>
                <input 
                  type="text" 
                  placeholder="Для каких задач вы бы хотели использовать ПК?" 
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal"
                  value={usageTasks}
                  onChange={handleUsageTasksChange}
                />
                <input 
                  type="text" 
                  placeholder="Предпочтения по сборке, например цвет" 
                  className="w-full p-3 mb-4 rounded-lg bg-[#d3dbdc] text-gunmetal"
                  value={buildPreferences}
                  onChange={handleBuildPreferencesChange}
                />
                <button className="bg-purple text-white text-pm lg:text-p px-4 py-4 rounded-xl w-full">оставить заявку</button>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </section>
  );
};

export default HomePage;
