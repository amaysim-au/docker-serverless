# amaysim/serverless

[![npm](https://img.shields.io/npm/v/serverless)](https://www.npmjs.com/package/serverless)
[![deploy status](https://github.com/amaysim-au/docker-serverless/workflows/Deploy/badge.svg)](https://github.com/amaysim-au/docker-serverless/actions)
[![image version](https://img.shields.io/docker/v/amaysim/serverless?label=image%20version)](https://hub.docker.com/r/amaysim/serverless)
[![docker pulls](https://img.shields.io/docker/pulls/amaysim/serverless)](https://hub.docker.com/r/amaysim/serverless)
[![docker image size](https://img.shields.io/docker/image-size/amaysim/serverless)](https://hub.docker.com/r/amaysim/serverless)
[![License](https://img.shields.io/dub/l/vibe-d.svg)](LICENSE)

[![Serverless Application Framework AWS Lambda API Gateway](./assets/serverless-framework.png)](http://serverless.com)

Docker image containing NodeJS, Serverless Framework and Yarn

## Usage

### Docker run command

```bash
# running Serverless version 1.72.0
$ docker run --rm amaysim/serverless:1.72.0 serverless --help
```

## Development

### Prerequisites

- Docker
- Buildx
- Make

### Build image locally

```bash
# build image locally with latest Serverless version
$ make build

# build image locally with specific Serverless version
$ make build SERVERLESS_VERSION=1.72.0

# go inside the container
$ make shell

# testing multi arch build with buildx
# you may need to create a builder first
$ docker buildx create --name mybuilder --use
$ make buildMultiArch

# run the test
$ make ciTest
```

## Docker image update automation

Periodically, once a week, a new amaysim/serverless Docker image containing the lastest version of Serverless is being built with [GitHub Actions](https://github.com/amaysim-au/docker-serverless/actions). This means that there is no need for someone to manually update and tag the image whenever there is a new Serverless version.

## Contributing

The project follows the typical [GitHub pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) model. Before starting any work, please either comment on an existing issue, or file a new one.

1. [Fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) this repository
1. Clone the forked repository
1. Create a new branch with a meaningful name (optional)
1. Make your changes
1. Test locally (see section "Development")
1. Commit and push your changes
1. Create a [pull request from a fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork)

## Docker image

The Docker image has the following:

- Node LTS (12.14.0) Alpine: we leverage Babel to be compatible with AWS Lambda runtime
- [Serverless Framework](https://serverless.com/framework/)
- [yarn](https://github.com/yarnpkg/yarn)
- zip: handy to zip your own serverless artifact
- [AWS CLI](https://github.com/aws/aws-cli): required by some Serverless plug-ins to work

## References

- https://docs.docker.com/desktop/multi-arch/
- https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
- https://github.com/docker/setup-buildx-action
