FROM alpine

ARG ARIANG_VERSION=1.0.0

ENV DOMAIN=0.0.0.0:8080
ENV ARIA2RPCPORT=8080

RUN apk update \
    && apk add --no-cache --update caddy aria2 su-exec

# AriaNG
WORKDIR /usr/local/www/ariang

RUN wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip \
    -O ariang.zip \
    && unzip ariang.zip \
    && rm ariang.zip \
    && chmod -R 755 ./

WORKDIR /aria2

COPY aria2.conf ./conf-copy/aria2.conf
COPY start.sh ./
COPY Caddyfile /usr/local/caddy/

VOLUME /aria2/data
VOLUME /aria2/conf

EXPOSE 8080

ENTRYPOINT ["/bin/sh"]
CMD ["./start.sh"]

LABEL org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="MIT" \
    org.label-schema.name="ariang" \
    org.label-schema.vendor="hurlenko" \
    org.label-schema.url="https://github.com/hurlenko/aria2-ariang-docker/" \
    org.label-schema.vcs-url="https://github.com/hurlenko/aria2-ariang-docker.git" \
    org.label-schema.vcs-type="Git"