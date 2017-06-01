'use strict';

const assert = require('assert');
const greeting = require('../../src/greeting');
const currentGreetingMessage = process.env.GREETING_MESSAGE;

describe('greeting.greet()', function() {
  afterEach(function () {
    process.env.GREETING_MESSAGE = currentGreetingMessage;
  });

  it('should return GREETING_MESSAGE value if set', function () {
    process.env.GREETING_MESSAGE = "Welcome to Amaysim Serverless";
    assert.equal(greeting.greet(), "Welcome to Amaysim Serverless");
  });

  it('should return "GREETING_MESSAGE is not set" if not set', function() {
    process.env.GREETING_MESSAGE = "";
    assert.equal(greeting.greet(), "GREETING_MESSAGE is not set");
  });
});