FROM node:lts-alpine

LABEL maintainer="Amaysim Australia"
LABEL application="Docker Serverless"

ARG SERVERLESS_VERSION=latest
ARG PYTHON_VERSION=3.8.2-r0

ENV PYTHON_VERSION $PYTHON_VERSION
ENV SERVERLESS_VERSION $SERVERLESS_VERSION

# Install dependencies including AWS
RUN apk --no-cache add python python3==$PYTHON_VERSION python3-dev==$PYTHON_VERSION bash ca-certificates curl g++ git groff jq less make openssh py-pip wget zip && \
    pip --no-cache-dir install awscli && \
    update-ca-certificates

# glibc required
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk && \
    rm -f glibc-2.25-r0.apk

# Get yarn working
RUN mkdir -p /tmp/yarn && \
    mkdir -p /opt/yarn/dist && \
    cd /tmp/yarn && \
    wget -q https://yarnpkg.com/latest.tar.gz && \
    tar zvxf latest.tar.gz && \
    find /tmp/yarn -maxdepth 2 -mindepth 2 -exec mv {} /opt/yarn/dist/ \; && \
    rm -rf /tmp/yarn

# Get yarn working round ii
RUN ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarn && \
    ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarnpkg && \
    yarn --version

# Install serverless
RUN yarn global add serverless@$SERVERLESS_VERSION

# Set the work directory
WORKDIR /opt/app
