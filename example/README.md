Example
=======

This example shows how to deploy to AWS using `aws-serverless` container.

It has 2 components:

- Kinesis defined in a cloudformation file
- 2 Lambda functions defined with Serverless Framework

Usage
-----

```bash
# copy env.list.template to env.list and fill out env.list
$ cp ../env.list.template ../env.list
$ vim env.list
#

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