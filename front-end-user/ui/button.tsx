import { Jura } from "next/font/google";

const jura = Jura({ 
    subsets: ["latin", "cyrillic"],
    weight: ['400', '500', '700'],
   });

export default function Button() {
  
  return (
    <button className={jura.className} style={{
        width: 261,
        height: 72,
        borderRadius: 20,
        backgroundColor: "#6240A9"
    }}
    >
      <p style={{
          fontSize: 24,
          fontWeight: 700,
          color: "#E9EFF0",
          padding: "22px 28px",
      }}
      >
      Образец кнопки
      </p>
    </button>
  );
}

