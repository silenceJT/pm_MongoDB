module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {},
      },
    },
  },
  purge: {
    content: ["./app/**/*.html.erb"],
  }
  plugins: [
      // ...
      require('@tailwindcss/forms'),
    ]
}