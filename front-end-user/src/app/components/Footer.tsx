import React from 'react';

const Footer = () => {
  return (
    <footer className="bg-white text-gunmetal p-10 mt-auto">
      <div className="container mx-auto flex flex-col md:flex-row justify-between items-start space-y-6 md:space-y-0 md:space-x-56">
        <div className="flex flex-col space-y-1 text-footerm lg:text-footer">
          <a href="/" className="text-footerm lg:text-footer">Главная</a>
          <a href="/price-list" className="text-footerm lg:text-footer">Прайс-лист</a>
          <a href="/questions" className="text-footerm lg:text-footer">Вопросы</a>
          <a href="/about-us" className="text-footerm lg:text-footer">О нас</a>
          <a href="/contacts" className="text-footerm lg:text-footer">Контакты</a>
        </div>
        <div className="flex flex-col space-y-1 text-footerm lg:text-footer">
          <a href="/privacy-policy.pdf" className="text-footerm lg:text-footer">Политика конфиденциальности</a>
        </div>
        <div className="flex flex-col space-y-2 text-footerm lg:text-footer">
          <p className="text-footerm lg:text-footer">+7 (812) 999-99-99</p>
          <div className="flex space-x-4">
            <a href="https://vk.com/buildbox_spb" target="_blank" rel="noopener noreferrer">
              <img src="/vkontakteDark.svg" alt="VK" className="lg:w-8 lg:h-8 w-6 h-6" />
            </a>
            <a href="https://telegram.org" target="_blank" rel="noopener noreferrer">
              <img src="/telegramDark.svg" alt="Telegram" className="lg:w-8 lg:h-8 w-6 h-6" />
            </a>
            <a href="https://whatsapp.com" target="_blank" rel="noopener noreferrer">
              <img src="/whatsappDark.svg" alt="WhatsApp" className="lg:w-8 lg:h-8 w-6 h-6" />
            </a>
          </div>
          <p className="text-footerm lg:text-footer">build_box@mail.ru</p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
