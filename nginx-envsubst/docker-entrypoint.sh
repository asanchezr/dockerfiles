#!/usr/bin/env bash
set -e

#
# Generate {filename}.template files into {filename} with envvars (only existing) expanded on every run
#
if [[ ! -z $NGINX_CONFIG_TEMPLATE ]]; then
  echo $NGINX_CONFIG_TEMPLATE | envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" > /etc/nginx/nginx.conf
elif [[ ! -z $NGINX_CONFIG_TEMPLATE_B64 ]]; then
  echo $NGINX_CONFIG_TEMPLATE_B64 | base64 --decode | envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" > /etc/nginx/nginx.conf
else
  envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
fi

#
# HTTP Basic Authentication
#
if [[ ! -z $AUTH_USER && ! -z $AUTH_PASSWORD ]]; then
  htpasswd -c -b /etc/nginx/.htpasswd $AUTH_USER $AUTH_PASSWORD
fi

exec "$@"