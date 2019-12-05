FROM nginx:alpine

# Default values for supported variables
ENV NGINX_PORT=8080 \
    NGINX_HOST=_ \
    PROXY_TO=localhost:8025 \
    DNS_RESOLVER=8.8.8.8 \
    CLIENT_MAX_BODY_SIZE=1m \
    STATIC_FILES_ROOT=/usr/share/nginx/html

RUN apk add --no-cache \
    gettext \
    apache2-utils \
    bash \
    && rm -rf /tmp/* /var/tmp/*

COPY nginx.conf.template /etc/nginx/

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]