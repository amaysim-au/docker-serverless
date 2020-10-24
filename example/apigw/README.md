# AWS API Gateway Example

Greeting API using AWS Gateway and Lambda.

## Pre-requisites

- Docker
- Docker Compose
- AWS credentials in ~/.aws or environment variables
  > Environment variables can be defined inside your shell session using `export VAR=value` or setting them in .env file. See `.env.template` for more information.

## Installation

```bash
$ git clone https://github.com/amaysim-au/docker-serverless.git
$ cd docker-serverless/example/apigw/
```

## Usage

```bash
# Create .env file based on env.example
$ make envfile ENVFILE=env.example
# Install dependencies
$ make deps

# Test
$ make test
# Build
$ make build

# Deploy to AWS
$ make deploy
# You should see something like:
#   endpoints:
#     GET - https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/greet
$ curl https://xyz.execute-api.ap-southeast-2.amazonaws.com/dev/greet
# <html>
#   <body>
#     <h1>"Welcome to Amaysim Serverless"</h1>
#   </body>
# </html>

# Remove the api gateway
$ make remove
# Clean your folder
$ make clean
```
