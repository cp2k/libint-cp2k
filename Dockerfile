FROM jenkins/jnlp-slave:alpine

USER root

RUN set -ex ; \
    apk add --no-cache --virtual .build-deps \
        build-base \
        automake \
        autoconf \
        gmp-dev \
        boost-dev \
        curl \
        jq

USER jenkins
