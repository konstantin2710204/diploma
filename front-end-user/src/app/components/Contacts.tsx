import React from 'react';

const Contacts = () => {
  return (
    <section id="contacts" className="bg-obsidian text-white p-10">
      <div className="max-w-screen-lg mx-auto">
        <h2 className="text-h2m lg:text-h2 mb-8 text-center">Контакты</h2>
        <div className="flex flex-col md:flex-row justify-between items-stretch mb-24">
          <div className="bg-white text-gunmetal p-8 w-full md:w-1/3 flex-shrink-0">
            <h3 className="font-bold text-lg lg:text-2xl mb-4">
              Свяжитесь с нами уже сегодня и мы примем ваше устройство в работу
            </h3>
            <div className="mb-4 flex items-center">
              <img src="/phone.svg" alt="Phone" className="w-6 h-6 mr-2" />
              <p className="text-footerm lg:text-footer">+7 (812) 999-99-99</p>
            </div>
            <div className="mb-4 flex items-center">
              <img src="/address.svg" alt="Address" className="w-6 h-6 mr-2" />
              <p className="text-footerm lg:text-footer">10-я Красноармейская, 14</p>
            </div>
            <div className="mb-4 flex items-center">
              <img src="/calendar.svg" alt="Working hours" className="w-6 h-6 mr-2" />
              <div>
                <p className="text-footerm lg:text-footer">Пн-Пт: 10:00 - 21:00</p>
                <p className="text-footerm lg:text-footer">Сб-Вс: 12:00 - 21:00</p>
              </div>
            </div>
            <div className="flex space-x-4 pl-8">
              <a href="https://vk.com/buildbox_spb" target="_blank" rel="noopener noreferrer">
                <img src="/vkontakteDark.svg" alt="VK" className="w-6 h-6 lg:w-8 lg:h-8" />
              </a>
              <a href="https://telegram.org" target="_blank" rel="noopener noreferrer">
                <img src="/telegramDark.svg" alt="Telegram" className="w-6 h-6 lg:w-8 lg:h-8" />
              </a>
              <a href="https://whatsapp.com" target="_blank" rel="noopener noreferrer">
                <img src="/whatsappDark.svg" alt="WhatsApp" className="w-6 h-6 lg:w-8 lg:h-8" />
              </a>
            </div>
          </div>
          <div className="w-full md:w-2/3">
            <iframe
              className="w-full h-full"
              src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d500.04180031781476!2d30.299032469738982!3d59.91277239843137!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x469630f6d9cab5ef%3A0x9f0837d71793e74e!2s10-Ya%20Krasnoarmeyskaya%20Ulitsa%2C%2014%2C%20Sankt-Peterburg%2C%20190103!5e0!3m2!1sen!2sru!4v1718701939938!5m2!1sen!2sru"
              allowFullScreen=""
              loading="lazy"
            ></iframe>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Contacts;
