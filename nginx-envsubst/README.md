# nginx-envsubst

Nginx image with support for environment variables using [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)

## Usage

```sh
# to share a network with other containers/microservices
docker network create --driver bridge backend

docker run -d -p 80:80 -e UPSTREAM=mailhog:8025 --name nginx --network backend -v nginx.tmpl:/etc/nginx/nginx.tmpl your_dockerhub_username/nginx-envsubst

```

### Example `nginx.tmpl`

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
