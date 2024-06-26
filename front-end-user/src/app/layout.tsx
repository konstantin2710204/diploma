import type { Metadata } from "next";
import { Jura } from "next/font/google";
import "./globals.css";
import Header from "./components/Header";
import Footer from "./components/Footer";

const jura = Jura({ subsets: ["latin", "cyrillic"] });

export const metadata: Metadata = {
  title: "Build Box - мастерская по ремонту компьютеров",
  description: "Generated by create next app",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={jura.className}>
        <Header />
        {children}
        <Footer />
      </body>
    </html>
  );
}
