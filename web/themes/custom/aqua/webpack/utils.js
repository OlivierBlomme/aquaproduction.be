// utils.js
const path = require("path");
const webpackDir = path.resolve(__dirname);
const resources = [
  "../../../contrib/verdesoft_emulsify/components/00-base/**/*.scss",
];

module.exports = resources.map(file => path.resolve(webpackDir, file));