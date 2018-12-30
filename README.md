## [Aria2](https://github.com/aria2/aria2) + [AriaNg](https://github.com/mayswind/AriaNg)

[![](https://images.microbadger.com/badges/image/wahyd4/aria2-ui.svg)](https://microbadger.com/images/wahyd4/aria2-ui "Get your own image badge on microbadger.com")

- [Features](#features)
- [How to run](#how-to-run)
  - [Simple Usage](#simple-usage)
  - [Full Usage](#full-usage)
  - [Supported Environment Variables](#supported-environment-variables)
  - [Supported Volumes](#supported-volumes)
- [Docker Hub](#docker-hub)
- [Usage it in Docker compose](#usage-it-in-docker-compose)

### Aria2
![Screenshot](https://github.com/wahyd4/aria2-ariang-x-docker-compose/raw/master/images/ariang.png)

## Features

* Aria2
* AriaNg
* Basic Auth

## How to run

### Simple Usage

```bash
  docker run -d --name aria2-ui -p 80:80 -p 6800:6800 wahyd4/aria2-ui
```

* Aria2: <http://yourip>
* Please use `admin`/`admin` as username and password to login

### Full Usage

```bash
  docker run -d --name ariang -p 80:80 -p 6800:6800 -p 443:443 -e ENABLE_AUTH=true -e RPC_SECRET=Hello -e DOMAIN=example.com -e ARIA2_USER=user -e ARIA2_PWD=pwd -v /yourdata:/data -v /yoursslkeys/:/root/conf/key -v /<to your aria2.conf>:/root/conf/aria2.conf wahyd4/aria2-ui
```

### Supported Environment Variables

  * `ENABLE_AUTH` enable Basic auth
  * `ARIA2_USER` Basic Auth username
  * `ARIA2_PWD` Basic Auth
  * `RPC_SECRET` The Aria2 RPC secret token
  * `DOMAIN` The domain you'd like to bind


### Supported Volumes

  * `/data` The folder of all Aria2 downloaded files.
  * `/root/conf/aria2.conf` The Aria2 configuration file.

### How to build

```bash
cd caddy
docker build -t aria2-ui .
```

## Docker Hub

  <https://hub.docker.com/r/wahyd4/aria2-ui/>

## Usage it in Docker compose

  Please refer <https://github.com/wahyd4/aria2-ariang-x-docker-compose>
