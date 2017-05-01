#!/bin/bash

# Generic entry script that allows normal environment variables
# to be converted to habitat configuration
#
# Example usage:
# 
#   docker run -e REDIS_PASSWORD=foobar REDIS_PORT=1234 dingotiles/redis32
#
# is the equivalent of normal habitat/docker usage:
#
#   docker run -e HAB_REDIS='password=foobar port=1234' dingotiles/redis32

set -e

service=$(cat /.hab_pkg)
service=$(echo "${service#*/}" | tr '[:lower:]' '[:upper:]')

env | \
  egrep "(HAB_)?${service}_.*=" | \
  sed "s/HAB_//" | \
  sed "s/${service}_\(.*\)=\(.*\)/\1 = \"\2\"/g" | \
  tr '[:upper:]' '[:lower:]' > /env.toml

eval "export HAB_${service}='$(cat /env.toml)'"

exec /init.sh "$@"
