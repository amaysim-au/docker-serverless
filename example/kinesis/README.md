> WORK IN PROGRESS. DO NOT USE IT YET


Example
=======

This example shows how to deploy to AWS using `aws-serverless` image.

It has 2 components:

- Kinesis defined in a cloudformation file
- 2 Lambda functions defined with Serverless Framework

Usage
-----

> By default, the commands are using the image `aws-serverless` but this can be changed by setting the environment variable `IMAGE_NAME` to, for instance, `amaysim/aws-serverless:1.4.0`.

```bash
# copy env.list.template to env.list and fill out env.list
$ cp env.list.template env.list
$ vim env.list

# deploy Kinesis and lambdas
$ make deploy
# push some data to kinesis
$ make push
# look at the logger's log
$ make log
# delete the lambdas and kinesis
$ make delete
# clean the environment
$ make clean
```