/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["../content/**/*.md", "../layouts/**/*.html"],
  theme: {
    extend: {},
  },
  // darkMode: 'class',
  plugins: [require("@tailwindcss/typography")],
}

