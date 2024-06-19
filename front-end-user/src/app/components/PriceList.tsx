import React from 'react';

const PriceList = () => {
  return (
    <section id="price-list" className="bg-obsidian text-white p-10">
      <div className="max-w-screen-lg mx-auto">
        <h2 className="text-h1m lg:text-h1 mb-8 text-center">Прайс-лист</h2>

        {/* Диагностика */}
        <div className="bg-gray p-6 rounded-2xl mb-8">
          <h3 className="text-h3m lg:text-h3 mb-4">Диагностика</h3>
          <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
            <li className="flex justify-between">
              <span>Ноутбуки и видеокарты<br/>(не включается)</span>
              <span>1 000₽</span>
            </li>
            <li className="flex justify-between">
              <span>Ноутбуки и видеокарты<br/>(плавающие дефекты)</span>
              <span>от 3 000₽</span>
            </li>
            <li className="flex justify-between">
              <span>Системные блоки<br/>(не включается)</span>
              <span>от 3 000₽</span>
            </li>
            <li className="flex justify-between">
              <span>Системные блоки<br/>(плавающие дефекты)</span>
              <span>от 5 000₽</span>
            </li>
            <li className="flex justify-between">
              <span>Срочная диагностика</span>
              <span>2 000₽</span>
            </li>
          </ul>
        </div>

        {/* Видеокарты */}
        <h3 className="text-h2m lg:text-h2 mb-4">Видеокарты</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
          <div className="bg-gray p-6 rounded-2xl">
            <h3 className="text-h3m lg:text-h3 mb-4">Ремонт</h3>
            <div className="mb-4">
              <div className="bg-red rounded-lg">
                <h3 className="text-h3m lg:text-h3 ml-3 p-2">AMD</h3>
              </div>
              <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
                <li className="flex justify-between">
                  <span>RX 5700 XT</span>
                  <span>от 3 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RX 6800 / 6800 XT</span>
                  <span>от 3 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RX 6900 / 6900 XT</span>
                  <span>от 4 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RX 7900 XT / 7900 XTX</span>
                  <span>от 6 000₽</span>
                </li>
              </ul>
            </div>
            <div>
              <div className="bg-green rounded-lg">  
                <h3 className="text-h3m lg:text-h3 ml-3 p-2">NVIDIA</h3>
              </div>
              <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
                <li className="flex justify-between">
                  <span>GTX 1660 SUPER / Ti</span>
                  <span>от 3 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 3060 / 3060 Ti</span>
                  <span>от 3 500₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 3070</span>
                  <span>от 3 500₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 3080 / Ti / 3090</span>
                  <span>от 4 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 4070 Ti / 4080</span>
                  <span>от 8 000₽</span>
                </li>
              </ul>
            </div>
          </div>
          <div className="bg-gray p-6 rounded-2xl">
            <h3 className="text-h3 mb-4">Обслуживание</h3>
            <div className="mb-4">
              <div className="bg-red rounded-lg">
                <h3 className="text-h3m lg:text-h3 ml-3 p-2">AMD</h3>
              </div>
              <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
                <li className="flex justify-between">
                  <span>RX 5700 XT</span>
                  <span>от 3 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RX 6800 / 6800 XT</span>
                  <span>от 3 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RX 6900 / 6900 XT</span>
                  <span>от 4 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RX 7900 XT / 7900 XTX</span>
                  <span>от 6 000₽</span>
                </li>
              </ul>
            </div>
            <div>
              <div className="bg-green rounded-lg">  
                <h3 className="text-h3m lg:text-h3 ml-3 p-2">NVIDIA</h3>
              </div>
              <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
                <li className="flex justify-between">
                  <span>GTX 1660 SUPER / Ti</span>
                  <span>от 3 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 3060 / 3060 Ti</span>
                  <span>от 3 500₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 3070</span>
                  <span>от 3 500₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 3080 / Ti / 3090</span>
                  <span>от 4 000₽</span>
                </li>
                <li className="flex justify-between">
                  <span>RTX 4070 Ti / 4080</span>
                  <span>от 8 000₽</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* Ноутбуки */}
        <h2 className="text-h2m lg:text-h2 mb-4">Ноутбуки</h2>
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div className="bg-gray p-4 rounded-2xl mb-8 flex items-center text-pm lg:text-p">
            <img src="/warning.svg" alt="Warning" className="w-6 h-6 lg:w-6 lg:h-6 mr-8 ml-2 lg:ml-4" />
            <span>Не берем в работу ноутбуки<br />старше 2020 года</span>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
          <div className="bg-gray p-6 rounded-2xl">
            <h3 className="text-h3m lg:text-h3 mb-4">Ремонт</h3>
            <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
              <li className="flex justify-between">
                <span>Замена разъема</span>
                <span>от 3 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Замена клавиатуры</span>
                <span>от 3 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Замена матрицы</span>
                <span>от 6 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Замена чипсета</span>
                <span>от 3 500₽</span>
              </li>
              <li className="flex justify-between">
                <span>Замена CPU</span>
                <span>от 4 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Замена GPU</span>
                <span>от 4 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Замена видеопамяти</span>
                <span>от 4 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Устранение залития</span>
                <span>от 6 000₽</span>
              </li>
            </ul>
          </div>
          <div className="bg-gray p-6 rounded-2xl">
            <h3 className="text-h3m lg:text-h3 mb-4">Обслуживание</h3>
            <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
              <li className="flex justify-between">
                <span>Обслуживание офисных <br />ноутбуков</span>
                <span>3 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Обслуживание игровых <br />ноутбуков</span>
                <span>5 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Обслуживание игровых <br />ноутбуков на жидком <br />металле</span>
                <span>7 000₽</span>
              </li>
              <li className="flex justify-between">
                <span>Срочное обслуживание <br />(1,5 часа)</span>
                <span>+1 000₽</span>
              </li>
            </ul>
          </div>
        </div>

        {/* Материнские платы */}
        <h2 className="text-h2m lg:text-h2 mb-4">Материнские платы</h2>
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div className="bg-gray p-4 rounded-2xl mb-8 flex items-center text-pm lg:text-p">
            <img src="/warning.svg" alt="Warning" className="w-6 h-6 lg:w-8 lg:h-8 mr-8 ml-4" />
            <span>Берем в работу платы только на сокетах AM4, AM5, LGA1700, LGA1200</span>
          </div>
        </div>
        <div className="bg-gray p-6 rounded-2xl mb-8">
        <h3 className="text-h3m lg:text-h3 mb-4">Ремонт</h3>
          <ul className="space-y-2 text-pm lg:text-p mx-0 my-5 lg:mx-5">
            <li className="flex justify-between">
              <span>Замена сокета<br/>LGA1200</span>
              <span>от 3 000₽</span>
            </li>
            <li className="flex justify-between">
              <span>Замена сокета<br/>AM4</span>
              <span>от 3 000₽</span>
            </li>
            <li className="flex justify-between">
              <span>Замена сокета<br/>LGA1700</span>
              <span>от 3 500₽</span>
            </li>
            <li className="flex justify-between">
              <span>Замена сокета<br/>AM5</span>
              <span>от 4 000₽</span>
            </li>
          </ul>
        </div>

        
      </div>
    </section>
  );
};

export default PriceList;
