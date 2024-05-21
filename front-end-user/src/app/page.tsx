import "../../ui/globals.css"

export default function Home() {
  return (
    <>
    <div className="bg-[#141315]">
      <div className="flex flex-col items-center min-h-screen">
        <div className="w-full max-w-screen-xl mx-auto relative">
          {/* <!-- Изображение с логотипом, выровненное относительно начала контейнера --> */}
          <div className="relative" style={{height: 280}}>
           <img src="comp.svg" alt="BUILD BOX Logo" className="absolute" />
          </div>
          {/* <!-- Основной контент сетки --> */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 p-4 w-full">
           {/* <!-- Левый блок с информацией о ремонте --> */}
            <div className="bg-[#092327] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[28px] pr-[48px]">
              <h2 className="font-jura font-bold text-[36px] mb-[65px]">
               Сломалась техника? Обращайтесь за помощью в Build Box!
              </h2>
              <p className="font-jura font-medium text-[24px] mb-[61px] mr-[245px]">
               Диагностика в течение 3-х рабочих дней
              </p>
              <button className="bg-[#E9EFF0] text-[#092327] font-jura font-bold text-[24px] lg:text-xl py-5 px-7 rounded-[1.25rem] focus:outline-none hover:bg-opacity-90">
               отправить на ремонт
              </button>
            </div>
            {/* <!-- Правый блок с информацией о сборке ПК --> */}
            <div className="bg-[#E9EFF0] text-[#092327] rounded-[1.25rem] shadow-lg p-[28px] pr-[80px]">
             <h2 className="font-jura font-bold text-[36px] mb-[65px]">
              Хотите собрать ПК,<br/>но не знаете как?<br/>Мы соберем его за вас!
             </h2>
             <p className="font-jura font-medium text-[24px] mb-[61px] mr-[35px]">
              Наши специалисты подберут наиболее оптимальное решение для ваших задач
             </p>
             <button className="bg-[#6240A9] text-[#E9EFF0] font-jura font-bold text-[24px] lg:text-xl py-5 px-7 rounded-[1.25rem] focus:outline-none hover:bg-opacity-90">
              связаться с нами
             </button>
             </div>
             <div>
              <img src="person.svg" alt="Работник Build Box" />
             </div>
             <div className="bg-[#092327] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[28px] pr-[53px]">
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-['-'] before:left-0 before:top-0 before:-translate-y-0 text-[24px] font-medium mb-[17px] pl-[30px]">опыт в ремонте техники более 10 лет</li>
                <li className="relative before:absolute before:content-['-'] before:left-0 before:top-0 before:-translate-y-0 text-[24px] font-medium mb-[17px] pl-[30px]">использование<br />качественного обрудования<br />и расходных материалов</li>
                <li className="relative before:absolute before:content-['-'] before:left-0 before:top-0 before:-translate-y-0 text-[24px] font-medium mb-[17px] pl-[30px]">квалифицированные мастера</li>
                <li className="relative before:absolute before:content-['-'] before:left-0 before:top-0 before:-translate-y-0 text-[24px] font-medium mb-[17px] pl-[30px]">помещение в центре города</li>
                <li className="relative before:absolute before:content-['-'] before:left-0 before:top-0 before:-translate-y-0 text-[24px] font-medium mb-[41px] pl-[30px]">более 1000 отзывов<br />на Яндекс.Картах, 2ГИС и Google Maps</li>
              </ul>

              <button className="bg-[#E9EFF0] text-[#092327] font-jura font-bold text-[24px] lg:text-xl py-5 px-7 rounded-[1.25rem] focus:outline-none hover:bg-opacity-90">
               +7 (812) 999-99-99
              </button>
             </div>
           </div>
         </div>
       </div>

      <div>
        <h1 className="text-center text-[42px] font-bold text-[#E9EFF0] font-jura mt-[80px] mb-[25px]">Прайс-лист</h1>
        <div className="flex flex-col items-center min-h-screen">
          <div className="w-full max-w-screen-xl mx-auto relative">
            <div className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-4 w-full">
             <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[28px] pr-[48px]">
              <h3 className="font-jura font-bold text-[32px] mb-[30px]">
               Диагностика
              </h3>
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">Ноутбуки и видеокарты (не включается)</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">Ноутбуки и видеокарты (плавающие дефекты)</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">Системные блоки (не включается)</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">Системные блоки (плавающие дефекты)</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[25px] font-medium pl-[30px]">Срочная диагностика</li>
              </ul>
             </div>
            </div>
            <div className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-4 w-full">
              <h2 className="font-jura font-bold text-[36px] text-[#E9EFF0] mb-[15px]">
                Видеокарты
              </h2>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 p-0 w-full">
              <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] pb-[35px] pt-[35px]">
              <h3 className="font-jura font-bold text-[32px] mb-[30px] pl-[13px]">
               Ремонт
              </h3>
              <div className="bg-[#710810] text-[#E9EFF0] rounded-[1.0rem] align">
               <h3 className="font-jura font-bold text-[32px] mb-[30px] p-[16px] pl-[26px]">
                AMD
               </h3>
              </div>
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 5700 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6600 / 6600 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6800 / 6800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6900 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 7700 XT / 7800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[20px] font-medium pl-[30px]">RX 7900 XT / 7900 XTX</li>
              </ul>
              <div className="bg-[#588200] text-[#E9EFF0] rounded-[1.0rem]">
               <h3 className="font-jura font-bold text-[32px] mb-[30px] p-[16px] pl-[26px]">
                NVIDIA
               </h3>
              </div>
                <ul className="list-none pl-0">
                 <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">GTX 1660 SUPER | Ti</li>
                 <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3060 / 3060 Ti</li>
                 <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3070</li>
                 <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3070 Ti / 3080</li>
                 <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3080 Ti / 3090</li>
                 <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 4070 Ti / 4080</li>
                 <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[20px] font-medium pl-[30px]">RTX 4090</li>
                </ul>
               </div>
               <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] pb-[35px] pt-[35px]">
              <h3 className="font-jura font-bold text-[32px] mb-[30px] pl-[13px]">
               Обслуживание
              </h3>
              <div className="bg-[#710810] text-[#E9EFF0] rounded-[1.0rem]">
               <h3 className="font-jura font-bold text-[32px] mb-[30px] p-[16px] pl-[26px]">
                AMD
               </h3>
              </div>
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 5700 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6600 / 6600 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6800 / 6800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6900 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 7700 XT / 7800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[20px] font-medium pl-[30px]">RX 7900 XT / 7900 XTX</li>
              </ul>
              <div className="bg-[#588200] text-[#E9EFF0] rounded-[1.0rem]">
               <h3 className="font-jura font-bold text-[32px] mb-[30px] p-[16px] pl-[26px]">
                NVIDIA
               </h3>
              </div>
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">GTX 1660 SUPER | Ti</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3060 / 3060 Ti</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3070</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3070 Ti / 3080</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 3080 Ti / 3090</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RTX 4070 Ti / 4080</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[20px] font-medium pl-[30px]">RTX 4090</li>
              </ul>
             </div>
              </div>
            </div>
            <div className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-4 w-full">
              <h2 className="font-jura font-bold text-[36px] text-[#E9EFF0] mb-[15px]">
                Ноутбуки
              </h2>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 p-0 w-full">
                <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] flex">
                  <img src="icons/warning.svg" alt="warning" className="p-[19px] pr-[18px]"/>
                  <p className="text-[24px] mb-[4px] font-medium pl-[7px]">Не берем в работу ноутбуки<br/> старше 2020 года</p>
                </div>
              </div>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 p-0 w-full">
              <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] pb-[35px] pt-[35px]">
              <h3 className="font-jura font-bold text-[32px] mb-[30px] pl-[13px]">
               Ремонт
              </h3>
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 5700 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6600 / 6600 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6800 / 6800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6900 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 7700 XT / 7800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[20px] font-medium pl-[30px]">RX 7900 XT / 7900 XTX</li>
              </ul>
               </div>
               <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] pb-[35px] pt-[35px]">
                <h3 className="font-jura font-bold text-[32px] mb-[30px] pl-[13px]">
                 Обслуживание
                </h3>
                <ul className="list-none pl-0">
                  <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 5700 XT</li>
                  <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6600 / 6600 XT</li>
                  <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6800 / 6800 XT</li>
                  <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6900 XT</li>
                  <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 7700 XT / 7800 XT</li>
                  <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[20px] font-medium pl-[30px]">RX 7900 XT / 7900 XTX</li>
                </ul>
               </div>
              </div>
            </div>
            <div className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-4 w-full">
              <h2 className="font-jura font-bold text-[36px] text-[#E9EFF0] mb-[15px]">
                Материнские платы
              </h2>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 p-0 w-full">
                <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] flex">
                  <img src="icons/warning.svg" alt="warning" className="p-[19px] pr-[18px]"/>
                  <p className="text-[24px] mb-[4px] font-medium pl-[7px]">Берем в работу только платы на<br />AM4, AM5, LGA1700, LGA1200</p>
                </div>
              </div>
              <div className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-0 w-full">
              <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] pb-[35px] pt-[35px]">
              <h3 className="font-jura font-bold text-[32px] mb-[30px] pl-[13px]">
               Ремонт
              </h3>
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 5700 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6600 / 6600 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6800 / 6800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 6900 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">RX 7700 XT / 7800 XT</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[20px] font-medium pl-[30px]">RX 7900 XT / 7900 XTX</li>
              </ul>
               </div>
              </div>
            </div>
            <div className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-4 w-full">
              <h2 className="font-jura font-bold text-[36px] text-[#E9EFF0] mb-[15px]">
                Системные блоки
              </h2>
              <div className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-0 w-full">
              <div className="bg-[#222222] text-[#E9EFF0] rounded-[1.25rem] shadow-lg p-[24px] pb-[35px] pt-[35px]">
              <ul className="list-none pl-0">
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">Обслуживание компьютеров</li>
                <li className="relative before:absolute before:content-[' '] before:left-0 before:top-0 before:-translate-y-0 text-[24px] mb-[4px] font-medium pl-[30px]">Сборка компьютеров на заказ</li>
              </ul>
               </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="">
        <h1 className="text-center text-[42px] font-bold text-[#E9EFF0] font-jura">Вопросы</h1>
         <details className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-4 w-full text-[#E9EFF0]">
          <summary className="grid grid-cols-1 lg:grid-cols-1 gap-7 p-4 w-full">
            <img src="icons/expand.svg" alt="+" className="" />
            Какую технику вы ремонтируете?
          </summary>
          <div className="grid grid-cols-1 lg:grid-cols-1 gap-2 p-4 w-full">
            <p>Мы занимаемся ремонтом ноутбуков, материнских плат, видеокарт и системных блоков</p>
          </div>
         </details>
      </div>
      <div>
        <h1 className="text-center text-[42px] font-bold text-[#E9EFF0] font-jura">О нас</h1>
      </div>
      <div>
        <h1 className="text-center text-[42px] font-bold text-[#E9EFF0] font-jura">Контакты</h1>
      </div>
    </div>
    </>
  );
}
