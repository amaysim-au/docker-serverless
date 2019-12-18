# amaysim/serverless

[![Serverless Application Framework AWS Lambda API Gateway](./assets/serverless-framework.png)](http://serverless.com)

[![serverless](http://public.serverless.com/badges/v3.svg)](http://www.serverless.com)

Docker image containing NodeJS, Serverless Framework and Yarn.

## Usage

### Build Locally

If you want to build and use your own local image

```bash
# build image locally
$ make build
# go inside the container
$ make shell
```

## Example

`example/apigw` is an example on how to use `amaysim/serverless`.

## Update Docker image

To update the Docker image after making changes/fixes follow the common steps below. The steps for updating the Serverless Framework and Node can be combined.

### New version of Serverless Framework

1. Change `SERVERLESS` of `Dockerfile`
2. Change `SERVERLESS_VERSION` of `Makefile`
3. Change version of docker-serverless in `example/apigw/docker-compose`
4. Follow common steps

### New version of Node

1. Run `docker pull node:lts-alpine`
2. Follow common steps

### Common steps

1. Build and test locally (test also the apigw example)
2. Commit and push the changes
3. Tag the commit with the command `$ make tag`
4. Go to [hub.docker.com](https://hub.docker.com/r/amaysim/serverless/)
5. In `Build Details` tab, you should now see the new tag kicking off

## Docker image

The Docker image has the following:

- Node LTS (12.14.0) Alpine: we leverage Babel to be compatible with AWS Lambda runtime
- [Serverless Framework](https://serverless.com/framework/)
- [yarn](https://github.com/yarnpkg/yarn)
- zip: handy to zip your own serverless artifact
- [AWS CLI](https://github.com/aws/aws-cli): required by some Serverless plug-ins to work
