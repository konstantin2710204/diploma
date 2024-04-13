// components/RepairForm.js
import React, { useState } from 'react';

function RepairForm({ closeForm }) {
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');

  const handleSubmit = async (event) => {
    event.preventDefault();
    const response = await fetch('http://localhost:8000/repair', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ name, phone }),
    });
    const data = await response.json();
    alert(`Ответ сервера: ${data.message}`);
    closeForm();
  };
  
  return (
    <>
      <div className="overlay active" onClick={closeForm}></div>
      <div className="modal active">
        <form onSubmit={handleSubmit}>
          <label>
            Имя:
            <input type="text" value={name} onChange={(e) => setName(e.target.value)} />
          </label>
          <label>
            Номер телефона:
            <input type="text" value={phone} onChange={(e) => setPhone(e.target.value)} />
          </label>
          <button type="submit">Отправить</button>
          <button type="button" onClick={closeForm}>Закрыть</button>
        </form>
      </div>
    </>
  );
}

export default RepairForm;
