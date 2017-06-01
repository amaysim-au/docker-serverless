'use strict'

module.exports.greet = () => {
  const message = process.env.GREETING_MESSAGE || "GREETING_MESSAGE is not set";
  console.log(message);
  return message;
}