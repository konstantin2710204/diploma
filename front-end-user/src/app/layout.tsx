import type { Metadata } from "next";
import { Jura } from "next/font/google";
import "../../ui/globals.css"

const jura = Jura({ 
  subsets: ["latin", "cyrillic"],
  weight: ['400', '500', '700'],
 });

export const metadata: Metadata = {
  title: "Компьютерная мастерская Build Box",
  description: "Добро пожаловать",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={jura.className}>
        <header className="bg-[#E9EFF0] text-[#092327] font-bold text-[20px] font-jura py-7">
            <nav>
              <ul className="flex justify-center space-x-4 sm:space-x-6 md:space-x-8 lg:space-x-12 xl:space-x-[100px]">
                <li><a href="/" className="hover:text-opacity-75">Главная</a></li>
                <li><a href="/" className="hover:text-opacity-75">Прайс-лист</a></li>
                <li><a href="/track-order" className="hover:text-opacity-75">Отслеживание заказа</a></li>
                <li><a href="/" className="hover:text-opacity-75">Вопросы</a></li>
                <li><a href="/" className="hover:text-opacity-75">О нас</a></li>
                <li><a href="/" className="hover:text-opacity-75">Контакты</a></li>
              </ul>
            </nav> 
          </header>
          {children}
          <footer>
            <p>Build Box 2024</p>
            </footer>
          </body>
    </html>
  );
}
