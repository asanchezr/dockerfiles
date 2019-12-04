# MailCatcher

Extra small mailcatcher image

## Overview

[MailCatcher](http://mailcatcher.me/) is an email testing tool for developers.

## Usage

```sh
# to share a network with other containers/microservices
docker network create --driver bridge backend

docker run -d -p 1080:1080 -p 1025:1025 --name mailcatcher --network backend your_dockerhub_username/mailcatcher
```

Link the container to another container and use the mailcatcher SMTP port `1025` via a ENV variable like `$MAILCATCHER_PORT_1025_TCP_ADDR`.