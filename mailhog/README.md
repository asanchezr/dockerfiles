# MailHog

Extra small mailhog image.

Inspired by [MailCatcher](http://mailcatcher.me/), easier to install.

* Download and run MailHog
* Configure your outgoing SMTP server
* View your outgoing email in a web UI
* Release it to a real mail server

Built with Go - MailHog runs without installation on multiple platforms.

## Overview

[MailHog](https://github.com/mailhog/MailHog) is an email testing tool for developers:

* Configure your application to use MailHog for SMTP delivery
* View messages in the web UI, or retrieve them with the JSON API
* Optionally release messages to real SMTP servers for delivery

## Usage

```sh
# to share a network with other containers/microservices
docker network create --driver bridge backend

docker run -d -p 1025:1025 -p 8025:8025 --name mailhog --network backend your_dockerhub_username/mailhog
```

Link the container to another container and use the mailcatcher SMTP port `1025` via a ENV variable like `$MAILHOG_PORT_1025_TCP_ADDR`.

## Recipes

### Running MailHog on port `25` with docker compose

docker-compose.yml

```yaml
version: "3"
services:
  smtp:
    image: mailhog/mailhog
    container_name: mailhog
    command: ["-smtp-bind-addr", "0.0.0.0:25"]
    user: root
    expose:
      - 25
      - 8025
    ports:
      - 8025:8025
    healthcheck:
      test: echo | telnet 127.0.0.1 25
```

from the containers declared on that same docker-compose.yml file, set the SMTP server to `smtp:25`.