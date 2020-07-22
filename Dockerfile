FROM node:lts-alpine

# SERVERLESS_VERSION is set explicitly in the Makefile used to build, otherwise
# use latest version.
ARG SERVERLESS_VERSION=latest
ENV SERVERLESS_VERSION $SERVERLESS_VERSION

RUN apk --no-cache add python python3 python3-dev py-pip ca-certificates groff less bash make jq curl wget g++ zip git openssh && \
    pip --no-cache-dir install awscli && \
    update-ca-certificates

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk && \
    rm -f glibc-2.25-r0.apk

RUN mkdir -p /tmp/yarn && \
    mkdir -p /opt/yarn/dist && \
    cd /tmp/yarn && \
    wget -q https://yarnpkg.com/latest.tar.gz && \
    tar zvxf latest.tar.gz && \
    find /tmp/yarn -maxdepth 2 -mindepth 2 -exec mv {} /opt/yarn/dist/ \; && \
    rm -rf /tmp/yarn

RUN ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarn && \
  ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarnpkg && \
  yarn --version

RUN yarn global add serverless@$SERVERLESS_VERSION

WORKDIR /opt/app
