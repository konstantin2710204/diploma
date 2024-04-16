import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Home from './components/Home';
import PriceList from './components/PriceList';
import OrderTracking from './components/OrderTracking';
import Reviews from './components/Reviews';
import Contacts from './components/Contacts';

function App() {
  return (
    <Router>
      <nav>
        <Link to="/">Home</Link>
        <Link to="/price-list">Price List</Link>
        <Link to="/order-tracking">Order Tracking</Link>
        <Link to="/reviews">Reviews</Link>
        <Link to="/contacts">Contacts</Link>
      </nav>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/price-list" element={<PriceList />} />
        <Route path="/order-tracking" element={<OrderTracking />} />
        <Route path="/reviews" element={<Reviews />} />
        <Route path="/contacts" element={<Contacts />} />
      </Routes>
    </Router>
  );
}

export default App;
