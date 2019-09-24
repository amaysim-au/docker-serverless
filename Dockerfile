FROM node:12-alpine
RUN apk --no-cache add python python3 python3-dev py-pip ca-certificates groff less bash make jq curl wget g++ zip git openssh && \
    pip --no-cache-dir install awscli && \
    update-ca-certificates

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
  
ENV SERVERLESS serverless@1.52.2
RUN yarn global add $SERVERLESS
WORKDIR /work
