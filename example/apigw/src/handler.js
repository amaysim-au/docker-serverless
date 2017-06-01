'use strict';

const greeting = require('./greeting');

module.exports.greet = (event, context, callback) => {
  return callback(null, greeting.greet());
}