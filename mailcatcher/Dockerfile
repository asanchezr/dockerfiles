FROM alpine:latest

# Set exit on error flag, install ruby deps, build mailcatcher, remove build deps
RUN set -e \
    && apk add --no-cache ruby ruby-bigdecimal ruby-json libstdc++ sqlite-libs \
    && apk add --no-cache --virtual .build-deps ruby-dev make g++ sqlite-dev \
    && gem install mailcatcher --no-ri --no-rdoc \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/tmp/*

# Default ports
EXPOSE 1025 1080

# Entrypoint: run mailcatcher process
CMD [ "mailcatcher", "--foreground", "--ip=0.0.0.0" ]
