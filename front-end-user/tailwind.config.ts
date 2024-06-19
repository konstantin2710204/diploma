import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        white: '#E9EFF0',
        obsidian: '#141315',
        gray: '#222222',
        gunmetal: '#092327',
        purple: '#6240A9',
        red: '#710810',
        green: '#588200',
      },
      fontFamily: {
        jura: ['Jura', 'sans-serif'],
      },
      fontSize: {
        h1: ['42px', { fontWeight: 'bold' }],
        h1m: ['32px', { fontWeight: 'bold' }],
        h2: ['36px', { fontWeight: 'bold' }],
        h2m: ['24px', { fontWeight: 'bold' }],
        h3: ['32px', { fontWeight: 'bold' }],
        h3m: ['24px', { fontWeight: 'bold' }],
        p: ['20px', { fontWeight: '500' }],
        pm: ['14px', { fontWeight: '500' }],
        navbar: ['20px', { fontWeight: 'bold' }],
        footer: ['20px', { fontWeight: 'light' }],
        footerm: ['14px', { fontWeight: 'light' }],
      },
    },
  },
  plugins: [],
};
export default config;
