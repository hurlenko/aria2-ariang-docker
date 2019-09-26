<p align="center">
  <img src="https://raw.githubusercontent.com/mayswind/AriaNg-Native/master/assets/AriaNg.ico" />
</p>

# [Aria2](https://github.com/aria2/aria2) + [AriaNg webui](https://github.com/mayswind/AriaNg) inside a [docker container](https://hub.docker.com/r/hurlenko/aria2-ariang)

[![Latest Github release](https://img.shields.io/github/release/hurlenko/aria2-ariang-docker.svg)](https://github.com/hurlenko/aria2-ariang-docker/releases/latest)
[![badge](https://images.microbadger.com/badges/image/hurlenko/aria2-ariang.svg)](https://microbadger.com/images/hurlenko/aria2-ariang "Get your own image badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/hurlenko/aria2-ariang.svg)](https://hub.docker.com/r/wahyd4/aria2-ui/)

## Introduction

AriaNg is a modern web frontend making [aria2](https://github.com/aria2/aria2) easier to use. AriaNg is written in pure html & javascript, thus it does not need any compilers or runtime environment. You can just put AriaNg in your web server and open it in your browser. AriaNg uses responsive layout, and supports any desktop or mobile devices.

## 🚩 Table of Contents

- [Screenshots](#-screenshots)
- [Demo website](#-demo-website)
- [Features](#-features)
- [Usage](#-usage)
  - [Docker](#docker)
  - [docker-compose](#docker-compose)
  - [Nginx](#running-behind-nginx-proxy)
  - [Ports desription](#ports-description)
  - [Supported environment variables](#supported-environment-variables)
  - [Supported volumes](#supported-volumes)
  - [User / Group identifiers](#user-/-group-identifiers)
- [Building](#-building)

## 🖼️ Screenshots

### Desktop

![AriaNg](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/desktop.png)

### Mobile device

![AriaNg](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/mobile.png)

## 🌐 Demo website

Please visit [http://ariang.mayswind.net/latest](http://ariang.mayswind.net/latest)

## 🎨 Features

- Confgurable via environment variables
- Uses the PUID and PGID evironment variables to map the container's internal user to a user on the host machine
- Supports multiple architectures: `amd64`, `arm64`

## 📙 Usage

### Docker

```bash
docker run -d --name ariang -p 80:80 -p 6800:6800 hurlenko/aria2-ariang
```

To run as a different user and to map custom volume locations use:

```bash
docker run -d \
    --name aria2-ui \
    -p 6800:6800 \                    # aria2 rpc
    -p 80:80 \                        # webui
    -v /DOWNLOAD_DIR:/aria2/data \    # replace /DOWNLOAD_DIR with your download directory in your host.
    -v /CONFIG_DIR:/aria2/conf \      # replace /CONFIG_DIR with your configure directory in your host.
    -e PUID=1000 \                    # replace 1000 with the userid who will own all downloaded files and configuration files.
    -e PGID=1000 \                    # replace 1000 with the groupid who will own all downloaded files and configuration files.
    -e RPC_SECRET=NOBODYKNOWSME \     # replace NOBODYKNOWSME with the secret to access Aria2 RPC services.
    hurlenko/aria2-ariang
```

### docker-compose

Minimal `docker-compose.yml` may look like this:

```yaml
version: "3"

services:
  ariang:
    image: hurlenko/aria2-ariang
    ports:
      - 80:80
      - 6800:6800
    volumes:
      - /DOWNLOAD_DIR:/aria2/data
      - /CONFIG_DIR:/aria2/conf
    environment:
      - PUID=1000
      - PGID=1000
      - RPC_SECRET=secret
      - DOMAIN=0.0.0.0:80
    restart: always
```

Simply run:

```bash
docker-compose up
```

### Running behind Nginx proxy

You can use this nginx config:

```nginx
location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    # proxy_set_header X-Forwarded-Proto https;
    proxy_redirect off;
    proxy_connect_timeout      240;
    proxy_send_timeout         240;
    proxy_read_timeout         240;
    proxy_pass http://127.0.0.1:80;
}

location /jsonrpc {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    # proxy_set_header X-Forwarded-Proto https;
    proxy_redirect off;
    proxy_connect_timeout      240;
    proxy_send_timeout         240;
    proxy_read_timeout         240;
    proxy_pass http://127.0.0.1:6800;
}
```

### Ports description

- `80` - AriaNg webui
- `6800` - aria2 rpc

### Supported environment variables

- `PUID` - Userid who will own all downloaded files and configuration files (Default `0` which is root)
- `PGID` - Groupid who will own all downloaded files and configuration files (Default `0` which is root)
- `RPC_SECRET` - The Aria2 RPC secret token. You can remove the secret by overriding `RPC_SECRET` with an empty string when running your container: `-e RPC_SECRET=""` (Default `secret`)
- `DOMAIN` - The domain you'd like to bind (Default `0.0.0.0:80`)

### Supported volumes

- `/aria2/data` The folder of all Aria2 downloaded files
- `/aria2/conf` The Aria2 configuration file

### User / Group identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```bash
id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## 🔨 Building

```bash
git clone https://github.com/hurlenko/aria2-ariang-docker
cd aria2-ariang-docker
docker build -t aria2-ui .
```
