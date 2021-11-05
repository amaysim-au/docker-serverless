FROM node:14-alpine

ENV SERVERLESS serverless@2.65.0

RUN apk --no-cache update && \
    apk --no-cache add \
        docker \
        python3 \
        python3-dev \
        py-pip \
        ca-certificates \
        groff \
        less \
        bash \
        make \
        jq \
        curl \
        wget \
        g++ \
        zip \
        git \
        openssh \
        postgresql-dev \
        yarn && \
    pip --no-cache-dir install awscli virtualenv && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/* && \
    yarn global add $SERVERLESS

WORKDIR /work