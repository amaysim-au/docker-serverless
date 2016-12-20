'use strict';

const AWS = require('aws-sdk');
const uuid = require('uuid');

module.exports.pushDataToKinesis = (event, context, callback) => {
  const data = event.data;
  const kinesis = new AWS.Kinesis();
  const partitionKey = uuid.v1();
  const params = {
    Data: data,
    PartitionKey: partitionKey,
    StreamName: '$STACK_NAME-Kinesis'
  };

  return kinesis.putRecord(params, (error, data) => {
    if (error) {
      callback(error);
    }
    callback(null, { message: 'Data successfully written to Kinesis stream' });
  });
};

module.exports.logger = (event, context, callback) => {
  // print out the event information on the console (so that we can see it in the CloudWatch logs)
  console.log(`The following data was written to the Kinesis stream:\n${JSON.stringify(event.Records[0].kinesis, null, 2)}`);
  callback(null, { event });
};
