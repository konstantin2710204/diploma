import React, { useEffect, useState } from 'react';
import Home from './components/Home';
import PriceList from './components/PriceList';
import OrderTracking from './components/OrderTracking';
import Reviews from './components/Reviews';
import AboutUs from './components/AboutUs';
import Contact from './components/Contact';
import RepairForm from './components/RepairForm';
import ContactForm from './components/ContactForm';

function App() {
  const [showRepairForm, setShowRepairForm] = useState(false);
  const [showContactForm, setShowContactForm] = useState(false);
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetch('/health')
      .then(response => response.json())
      .then(data => setMessage(data.status))
      .catch(error => console.error('Error fetching data: ', error));
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <p>
          API Status: {message}
        </p>
      </header>
      <nav>
        {/* Место для компонента навигации, если он будет добавлен */}
      </nav>

      <Home />
      <PriceList />
      <OrderTracking />
      <Reviews />
      <AboutUs />
      <Contact />

      <button onClick={() => setShowRepairForm(true)}>Отправить на ремонт</button>
      <button onClick={() => setShowContactForm(true)}>Связаться с нами</button>

      {showRepairForm && <RepairForm closeForm={() => setShowRepairForm(false)} />}
      {showContactForm && <ContactForm closeForm={() => setShowContactForm(false)} />}

    </div>
  );
}

export default App;
