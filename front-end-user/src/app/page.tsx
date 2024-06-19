import PriceList from "./components/PriceList";
import Questions from "./components/Questions";
import AboutUs from "./components/AboutUs";
import Contacts from "./components/Contacts";
import HomePage from "./components/HomePage";

export default function Home() {
  return (
    <main>
      <section id="home">
        <HomePage />
      </section>
      <section id="price-list">
        <PriceList />
      </section>
      <section id="faq">
        <Questions />
      </section>
      <section id="about-us">
        <AboutUs />
      </section>
      <section id="contacts">
        <Contacts />
      </section>
    </main>
  );
}
