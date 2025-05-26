# Arguments
ARG NODE_ALPINE_IMAGE=node:22.16.0-alpine3.21
FROM $NODE_ALPINE_IMAGE

ARG INSTALL_YARN_BERRY=true

# SERVERLESS_VERSION is set explicitly in the Makefile used to build, otherwise
# use latest version.
ARG SERVERLESS_VERSION=latest
ENV SERVERLESS_VERSION=$SERVERLESS_VERSION

# Install dependencies
RUN apk --no-cache add \
    python3 \
    python3-dev \
    py-pip \
    poetry \
    aws-cli \
    ca-certificates \
    groff \
    less \
    bash \
    make \
    cmake \
    jq \
    curl \
    wget \
    g++ \
    zip \
    git \
    openssh && \
    update-ca-certificates

# Install glibc for alpine
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk && \
    apk add --force-overwrite glibc-2.34-r0.apk && \
    rm -f glibc-2.34-r0.apk

# Enable Corepack and set Yarn to Berry version and install Serverless
RUN if [ "$INSTALL_YARN_BERRY" = true ]; then \
        npm install -g corepack && \
        corepack enable && \
        yarn set version berry && \
        yarn --version; \
    fi && \
    npm install -g serverless@$SERVERLESS_VERSION && \
    serverless --version

WORKDIR /opt/app