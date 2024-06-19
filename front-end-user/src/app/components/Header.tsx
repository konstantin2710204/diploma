'use client'

import React, { useState } from 'react';
import Link from 'next/link';
import { AiOutlineMenu, AiOutlineClose } from 'react-icons/ai';

const Header = () => {
  const [menuOpen, setMenuOpen] = useState(false);

  const toggleMenu = () => {
    setMenuOpen(!menuOpen);
  };

  const closeMenu = () => {
    setMenuOpen(false);
  };

  return (
    <header className="bg-white text-gunmetal lg:p-1 p-5">
      <nav className="flex lg:justify-center justify-between items-center relative">
        <div className="text-lg font-bold md:hidden">BUILD BOX</div>
        <div className="md:hidden">
          <button onClick={toggleMenu}>
            {menuOpen ? <AiOutlineClose size={24} /> : <AiOutlineMenu size={24} />}
          </button>
        </div>
        <ul
          className={`flex-col space-y-4 absolute bg-white p-5 top-16 left-0 right-0 transform md:flex md:flex-row md:space-x-20 md:static md:space-y-0 text-navbar transition-all duration-300 ease-in-out ${
            menuOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'
          } md:opacity-100 md:pointer-events-auto`}
        >
          <li onClick={closeMenu}>
            <Link href="/#home">Главная</Link>
          </li>
          <li onClick={closeMenu}>
            <Link href="/#price-list">Прайс-лист</Link>
          </li>
          <li onClick={closeMenu}>
            <Link href="/tracking/track-order">Отслеживание заказа</Link>
          </li>
          <li onClick={closeMenu}>
            <Link href="/#faq">Вопросы</Link>
          </li>
          <li onClick={closeMenu}>
            <Link href="/#about-us">О нас</Link>
          </li>
          <li onClick={closeMenu}>
            <Link href="/#contacts">Контакты</Link>
          </li>
        </ul>
      </nav>
    </header>
  );
};

export default Header;
