import React from 'react';

const AboutUs = () => {
  return (
    <section id="about-us" className="bg-obsidian text-white p-10">
      <div className="max-w-screen-lg mx-auto">
        <h2 className="text-h2m lg:text-h2 mb-8 text-center">О нас</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="md:col-span-2">
            <p className="text-footer mt-2">
              Добро пожаловать в наш сервисный центр, где профессионализм и забота о вашей технике объединяются!
            </p>
            <p className="text-footer mt-2">
              Мы — команда высококвалифицированных специалистов, специализирующихся в обслуживании и ремонте видеокарт и ноутбуков. Наша миссия — обеспечить вас качественными услугами по уходу за вашей техникой, чтобы вы могли наслаждаться её бесперебойной работой.
            </p>
          </div>
          <div>
            <h3 className="text-h3m lg:text-h3">Профессиональный опыт</h3>
            <p className="text-footer mt-2">
              Наши специалисты обладают обширным опытом в сфере ремонта и обслуживания техники. Мы следим за последними технологическими тенденциями, чтобы быть на передовых рубежах.
            </p>
          </div>
          <div>
            <h3 className="text-h3m lg:text-h3">Современное оборудование</h3>
            <p className="text-footer mt-2">
              Мы оснащены передовым техническим оборудованием, что позволяет проводить точную диагностику и эффективный ремонт вашего оборудования.
            </p>
          </div>
          <div>
            <h3 className="text-h3m lg:text-h3">Индивидуальный подход</h3>
            <p className="text-footer mt-2">
              Мы ценим уникальность каждого устройства и клиента. Предоставляем персонализированный подход, учитывая все ваши требования и особенности.
            </p>
          </div>
          <div>
            <h3 className="text-h3m lg:text-h3">Прозрачность и честность</h3>
            <p className="text-footer mt-2 mb-10">
              Мы стремимся к прозрачным отношениям и честности. Всегда информируем вас в процессе ремонта, а наши цены — честные и конкурентоспособные.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default AboutUs;
