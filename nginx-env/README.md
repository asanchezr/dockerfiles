# Out-of-the-box, Nginx with environment variables support

Nginx image with support for environment variables using [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)

## What is nginx?

> [wikipedia.org/wiki/Nginx](https://en.wikipedia.org/wiki/Nginx)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/nginx/logo.png)

## Usage

```sh
# to share a network with other containers/microservices
docker network create --driver bridge shared

docker run -it -p 8080:8080 -e PROXY_TO=mailhog:8025 --rm --name nginx-env --network shared nginx-env
```
### Example `nginx.conf.template`

```nginx
events {}

http {
  error_log stderr;
  access_log /dev/stdout;

  upstream backend {
    server ${UPSTREAM};
  }

  server {
    listen ${LISTEN_PORT};
    server_name ${SERVER_NAME};

    # Allow injecting extra configuration into the server block
    ${SERVER_EXTRA_CONF}

    location / {
      proxy_pass http://backend;
      proxy_redirect     off;
      proxy_set_header   Host $host;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Host $server_name;
    }
  }
}
```

## Changing the configuration

To change the configuration we use **Environment Variable**

```sh
docker run -it --rm --name some-nginx -p 8080:8080 -e NGINX_HOST=127.0.0.1.xip.io nginx
```

Then you can hit `http://127.0.0.1.xip.io:8080` in your browser.

Another example:

```sh
docker run -it --rm --name some-nginx -p 8080:8080 -v /local/src:/var/www -e STATIC_FILES_ROOT=/var/www/public your_dockerhub_username/nginx
```

And if you need to understand how the applied configuration looks like you can, in another console, run:

```sh
docker exec some-nginx cat /etc/nginx/conf.d/default.conf
```

### Available environment variables

Currently, these are the available variables, but they will depend on the tag you use:

- NGINX_PORT
- NGINX_HOST
- PROXY_TO
- STATIC_FILES_ROOT
- CLIENT_MAX_BODY_SIZE
- DNS_RESOLVER

> If you have extra needs you can either file an issue or see how to create
a complex configuration below

## Complex configuration

Every template file in the config folder `/etc/nginx/conf.d/*.template` will be generated replacing all environment
variables and included in the Nginx configuration.

You can then create a complex configuration:

- `.conf.template` will be added under the `http` directive, allowing you to add multiple `servers` if needed.
- `.rules.template` will be added under the main `server` template.

As an example, you can create your own Dockerfile to include extra rules and add your static files to be bundled together:

```dockerfile
FROM your_dockerhub_username/nginx

ADD config/templates/*.rules.template /etc/nginx/conf.d/

ADD src .
```

> Note: Your templates can still use variables to be replaced by envvars, making your image as flexible as this one.

## Using environment variables in Nginx configuration

Out-of-the-box, Nginx doesn't support environment variables inside most configuration blocks, but `envsubst` may be used as a workaround if you need to generate your Nginx configuration dynamically before Nginx starts.

Here is a few examples using docker-compose.yml:

```yaml
version: '3'

services:
  nginx:
    image: your_dockerhub_username/nginx
    ports:
     - "8080:8080"
    environment:
       PROXY_TO: "hello_world_app"

  hello_world_app:
    image: php:7.3-fpm
    command: |
          sh -c "
          mkdir /app;
          echo '<?php phpinfo(); ?>' > /app/index.php;
          php-fpm
          "
```

```yaml
version: '3'

services:
  web:
    image: your_dockerhub_username/nginx
    ports:
     - "8080:8081"
    environment:
       NGINX_HOST: "localhost"
       NGINX_PORT: "8081"
       PROXY_TO: "mailhog"
       CLIENT_MAX_BODY_SIZE: "10m"

  mailhog:
    image: your_dockerhub_username/mailhog
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