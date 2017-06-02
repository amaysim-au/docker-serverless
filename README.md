Docker AWS Serverless
======================

Docker image containing AWS CLI, AWS shell, NodeJS, Serverless Framework, and some scripts to ease AWS deployments.

Usage
------

### Build Locally

If you want to build and use your own local image

```bash
# build image locally
$ make dockerBuild
# go inside the container
$ make dockerShell
```

### Environment Variables

```
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
AWS_ACCOUNT_ID=

# Cloudformation stack name to be created/updated/deleted
STACK_NAME=
# the cloudformation file path
CFN_FILE=
# the cloudformation params file
CFN_PARAMS_FILE=
```

Those environment variables must all be set

- using a file and passing it to `docker run --env-file path/to/file` (see example)
- passing them to `docker run -e NAME1=value1 -e NAME2=value2`
- a mix of both

## Update Docker image

### New version of Serverless Framework

1. Change `SERVERLESS` of `Dockerfile`
2. Change `SERVERLESS_VERSION` of `Makefile`
3. Build and test locally
4. Commit and push the changes
5. Tag the commit with the command `make gitTag`
6. Go to [hub.docker.com](hub.docker.com)
7. In `Build Details` tab, you should now see the new tag kicking off

### Fix for the current version

1. Do the fixes you want to do
2. Build and test locally
3. Commit and push the changes
4. Run `make gitTag`
5. Go to [hub.docker.com](hub.docker.com)
6. In `Build Details` tab, you should now see build the tag kicking off

### Ways of using the image

Here are some ways of using the image

- running one container per command (see example)
- running a container and stay inside it to execute the commands

Docker image
------------

The Docker image has the following:

- Node 6.10 (Alpine)
- [aws-cli](https://github.com/aws/aws-cli)
- [aws-shell](https://github.com/awslabs/aws-shell)
- [Serverless Framework v1.4](https://serverless.com)
- [yarn](https://github.com/yarnpkg/yarn)
- zip: handy to zip your own serverless artefact
- envsubst: quite useful to create file based on a template using env vars

### Scripts

Some scripts has been written to help deploying to AWS (see example)

Name | Description
---|---
cfn-create-or-update.sh | Create or update a cloudformation
cfn-delete.sh | Delete a cloudformation
cfn-validate-template.sh | Validate a cloudformation template
