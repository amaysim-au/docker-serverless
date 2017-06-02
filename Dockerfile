FROM node:6.10-alpine
RUN apk --no-cache update && \
    apk --no-cache add python py-pip py-setuptools ca-certificates groff less bash make jq gettext-dev curl wget g++ zip && \
    pip --no-cache-dir install aws-shell && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*
WORKDIR /opt/yarn
RUN wget https://yarnpkg.com/latest.tar.gz && \
    tar zvxf latest.tar.gz && \
    rm latest.tar.gz
ENV PATH "$PATH:/opt/yarn/dist/bin"
RUN yarn --version
ENV SERVERLESS serverless@1.14.0
RUN yarn global add $SERVERLESS
COPY scripts /opt/scripts
ENV PATH "$PATH:/opt/scripts"
WORKDIR /opt/app