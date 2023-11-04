FROM alpine:3.16.0 as builder

ARG ARIANG_VERSION=1.3.6
RUN apk update
RUN apk add npm git
RUN npm install -g gulp

ADD https://github.com/mayswind/AriaNg/archive/refs/tags/${ARIANG_VERSION}.zip /ariang.zip
RUN mkdir -p /ariang
RUN unzip -x /ariang.zip  -d /ariang

COPY ./patchs /patchs

WORKDIR /ariang/AriaNg-${ARIANG_VERSION}
RUN git apply /patchs/*.patch
RUN npm install
RUN gulp clean build

FROM alpine:3.16.0

ARG ARIANG_VERSION=1.3.6
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="hurlenko" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="aria2-ariang" \
    org.label-schema.description="Aria2 downloader and AriaNg webui Docker image based on Alpine Linux" \
    org.label-schema.version=$ARIANG_VERSION \
    org.label-schema.url="https://github.com/hurlenko/aria2-ariang-docker" \
    org.label-schema.license="MIT" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/hurlenko/aria2-ariang-docker" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="hurlenko" \
    org.label-schema.schema-version="1.0"

RUN apk update \
    && apk add --no-cache --update caddy aria2 su-exec curl

# AriaNG
WORKDIR /usr/local/www/ariang

COPY --from=builder /ariang/AriaNg-${ARIANG_VERSION}/dist ./

WORKDIR /aria2

COPY aria2.conf ./conf-copy/aria2.conf
COPY start.sh ./
COPY Caddyfile /usr/local/caddy/

VOLUME /aria2/data
VOLUME /aria2/conf

EXPOSE 8080

ENTRYPOINT ["./start.sh"]
CMD ["--conf-path=/aria2/conf/aria2.conf"]
