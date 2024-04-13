import React from 'react';

function ContactForm({ closeForm }) {
  const handleSubmit = (event) => {
    event.preventDefault();
    closeForm();
  };

  return (
    <>
      <div className="overlay active" onClick={closeForm}></div>
      <div className="modal active">
        <form onSubmit={handleSubmit}>
          {/* Элементы формы */}
          <button type="button" onClick={closeForm}>Закрыть</button>
        </form>
      </div>
    </>
  );
}

export default ContactForm;
