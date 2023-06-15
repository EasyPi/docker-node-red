#
# Dockerfile for node-red
#

FROM alpine:3.12
MAINTAINER EasyPi Software Foundation

ARG NODERED_VERSION
ARG NODERED_DASHBOARD_VERSION

RUN set -xe \
    && apk add --no-cache \
        bash \
        build-base \
        ca-certificates \
        curl \
        dumb-init \
        gcompat \
        nodejs \
        nodejs-npm \
        python3 \
        python3-dev \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /lib /lib64 \
    && python -m ensurepip \
    && pip3 install --no-cache-dir rpi.gpio \
    && npm install -g --unsafe-perm \
        node-red@${NODERED_VERSION} \
        node-red-dashboard@${NODERED_DASHBOARD_VERSION} \
        node-red-node-email \
        node-red-node-feedparser \
        node-red-node-pi-gpio \
        node-red-node-sentiment \
        node-red-node-twitter \
        node-red-node-ui-list \
        node-red-node-ui-table \
    && mkdir -p /usr/share/doc/python-rpi.gpio \
    && apk del \
        build-base \
        python3-dev \
    && rm -rf /tmp/npm-*

WORKDIR /data
VOLUME /data

EXPOSE 1880

ENTRYPOINT ["dumb-init", "--"]
CMD ["node-red", "--userDir", "/data", "--flowFile", "flows.json"]
