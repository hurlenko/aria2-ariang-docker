FROM alpine

ARG ARIANG_VERSION=1.0.0

ENV RPC_SECRET=secret
ENV DOMAIN=0.0.0.0:80
ENV PUID=0
ENV PGID=0

RUN apk update \
    && apk add --no-cache --update caddy curl aria2 su-exec

# AriaNG
WORKDIR /usr/local/www/aria2

RUN curl -sL https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip \
    --output ariang.zip \
    && unzip ariang.zip \
    && rm ariang.zip \
    && chmod -R 755 ./

WORKDIR /aria2

COPY conf ./conf-copy
COPY aria2c.sh ./
COPY Caddyfile /usr/local/caddy/

RUN chmod +x aria2c.sh

# User downloaded files
VOLUME /aria2/data
VOLUME /aria2/conf

EXPOSE 6800
EXPOSE 80

CMD ["/bin/sh", "./aria2c.sh" ]