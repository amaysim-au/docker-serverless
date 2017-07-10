FROM node:6.10-alpine
RUN apk --no-cache update && \
    apk --no-cache add python py-pip ca-certificates groff less bash make jq curl wget g++ zip git openssh && \
    pip --no-cache-dir install awscli && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

# Install glibc
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk

WORKDIR /opt/yarn
RUN wget https://yarnpkg.com/latest.tar.gz && \
    tar zvxf latest.tar.gz && \
    rm latest.tar.gz
ENV PATH "$PATH:/opt/yarn/dist/bin"
RUN yarn --version
ENV SERVERLESS serverless@1.16.0
RUN yarn global add $SERVERLESS
WORKDIR /opt/app