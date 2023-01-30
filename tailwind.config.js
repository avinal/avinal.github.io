/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,elm,js}"],
  theme: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
};
