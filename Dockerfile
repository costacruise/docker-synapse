FROM docker.io/python:2-alpine3.7 as base

RUN apk add --no-cache --virtual .nacl_deps su-exec build-base libffi-dev zlib-dev libressl-dev libjpeg-turbo-dev linux-headers postgresql-dev libxslt-dev

ARG VERSION=0.30.0

ADD "https://github.com/matrix-org/synapse/archive/v$VERSION.tar.gz" /
RUN tar -xf "/v$VERSION.tar.gz" && mv /synapse-$VERSION/ /synapse
WORKDIR /synapse

RUN pip install --no-cache-dir --upgrade pip setuptools psycopg2 lxml \
 && pip install --no-cache-dir --upgrade --process-dependency-links . \
 && mv /synapse/contrib/docker/start.py /synapse/contrib/docker/conf /

VOLUME ["/data"]

EXPOSE 8008/tcp 8448/tcp

ENTRYPOINT ["/start.py"]