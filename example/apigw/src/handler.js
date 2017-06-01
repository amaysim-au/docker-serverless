'use strict';

const greeting = require('./greeting');

module.exports.greet = (event, context, callback) => {
  const html = `
  <html>
    <body>
      <h1>${greeting.greet()}</h1>
    </body>
  </html>`;

  const response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html',
    },
    body: html,
  };
  return callback(null, response);
}
