FROM node:8.4-alpine
RUN apk --no-cache update && \
    apk --no-cache add python python3==3.6.1-r3 python3-dev==3.6.1-r3 py-pip ca-certificates groff less bash make jq curl wget g++ zip git openssh && \
    pip --no-cache-dir install awscli && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

# Install glibc
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk

RUN mkdir -p /tmp/yarn && \
    mkdir /opt/yarn/dist
WORKDIR /tmp/yarn

RUN wget -q https://yarnpkg.com/latest.tar.gz && \
    tar zvxf latest.tar.gz && \
    find /tmp/yarn -maxdepth 2 -mindepth 2 -exec mv {} /opt/yarn/dist/ \; && \
    rm -rf /tmp/yarn

ENV PATH "$PATH:/opt/yarn/dist/bin"
RUN ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarn && \
    ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarnpkg
RUN yarn --version
ENV SERVERLESS serverless@1.23.0
RUN yarn global add $SERVERLESS
WORKDIR /opt/app
