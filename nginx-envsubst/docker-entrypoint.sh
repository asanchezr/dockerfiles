#!/usr/bin/env bash
set -e

if [[ ! -z $NGINX_CONFIG_TEMPLATE ]]; then
  echo $NGINX_CONFIG_TEMPLATE | envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" > /etc/nginx/nginx.conf
elif [[ ! -z $NGINX_CONFIG_TEMPLATE_B64 ]]; then
  echo $NGINX_CONFIG_TEMPLATE_B64 | base64 --decode | envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" > /etc/nginx/nginx.conf
else
  envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" < /etc/nginx/nginx.tmpl > /etc/nginx/nginx.conf
fi

if [[ ! -z $AUTH_USER && ! -z $AUTH_PASSWORD ]]; then
  htpasswd -c -b /etc/nginx/.htpasswd $AUTH_USER $AUTH_PASSWORD
fi

exec "$@"