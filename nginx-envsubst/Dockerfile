FROM nginx:alpine

ENV LISTEN_PORT=8080
ENV SERVER_NAME=_
ENV RESOLVER=8.8.8.8
ENV UPSTREAM=localhost:8025
ENV SERVER_EXTRA_CONF=

RUN apk add --no-cache \
    gettext \
    apache2-utils \
    bash \
    && rm -rf /tmp/* /var/tmp/*

COPY nginx.tmpl /etc/nginx/nginx.tmpl

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]