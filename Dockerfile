ARG NODE_ALPINE_IMAGE
FROM $NODE_ALPINE_IMAGE

# SERVERLESS_VERSION is set explicitly in the Makefile used to build, otherwise
# use latest version.
ARG SERVERLESS_VERSION=latest
ENV SERVERLESS_VERSION $SERVERLESS_VERSION

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

# Enable Corepack and set Yarn to Berry version
RUN npm install -g corepack && \
    corepack enable && \
    yarn set version berry && \
    yarn --version

# Use yarn dlx to run serverless without globally installing
RUN yarn dlx serverless@$SERVERLESS_VERSION --version

# Set working directory
WORKDIR /opt/app