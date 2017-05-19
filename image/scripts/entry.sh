#!/bin/bash

# Generic entry script that allows normal environment variables
# to be converted to habitat configuration
#
# Example usage:
#
#   docker run -e REDIS_PASSWORD=foobar REDIS_PORT=1234 dingotiles/dingo-redis
#
# is the equivalent of normal habitat/docker usage:
#
#   docker run -e HAB_REDIS='password=foobar port=1234' dingotiles/dingo-redis
#
# Enable SHIELD backup storage:
#
#   docker run -e REDIS_PASSWORD=foobar \
#              -e SHIELD_ENDPOINT=... \
#              -e SHIELD_PROVISIONING_KEY=... \
#              -e SHIELD_BACKUPS_STORE=... \
#              -e SHIELD_BACKUPS_RETENTION=... \
#              -e SHIELD_BACKUPS_SCHEDULE=... \
#       dingotiles/dingo-redis

set -e

service=$(cat /.hab_pkg)
service=$(echo "${service#*/}" | tr '[:lower:]' '[:upper:]')

env | \
  egrep "(HAB_)?${service}_.*=" | \
  sed "s/HAB_//" | \
  sed "s/${service}_\(.*\)=\(.*\)/\1 = \"\2\"/g" | \
  tr '[:upper:]' '[:lower:]' > /env.toml

if [[ "${SHIELD_ENDPOINT:-X}" != "X" ]]; then
  # $DOCKER_HOST_IP comes from jobs/cf-containers-shield-link/templates/bin/ctl
  echo "shield_agent_advertise_ip   = \"${DOCKER_HOST_IP:?required if enabling SHIELD backups}\"" >> /env.toml
  # $DOCKER_HOST_PORT_5444 comes from cf-containers-broker docker_manager.rb #append_port_binding_envvars method
  # when Settings.enable_host_port_envvar enabled
  echo "shield_agent_advertise_port = \"${DOCKER_HOST_PORT_5444:?required if enabling SHIELD backups}\"" >> /env.toml

  echo "bootstrap_from_backup =    true" >> /env.toml
  echo "shield_endpoint =          \"${SHIELD_ENDPOINT}\"" >> /env.toml
  echo "shield_skip_ssl_verify =   ${SHIELD_SKIP_SSL_VERIFY:-true}" >> /env.toml
  echo "shield_provisioning_key =  \"${SHIELD_PROVISIONING_KEY:?required if enabling SHIELD backups}\"" >> /env.toml
  echo "backups_store =            \"${SHIELD_BACKUPS_STORE:?required if enabling SHIELD backups}\"" >> /env.toml
  echo "backups_retention =        \"${SHIELD_BACKUPS_RETENTION:?required if enabling SHIELD backups}\"" >> /env.toml
  echo "backups_schedule =         \"${SHIELD_BACKUPS_SCHEDULE:?required if enabling SHIELD backups}\"" >> /env.toml
fi

echo /env.toml
cat /env.toml
eval "export HAB_${service}='$(cat /env.toml)'"

mkdir -p /config
echo "{\"hosthame\":\"localhost\",\"host\":\"localhost\",\"port\":6379,\"password\":\"$REDIS_PASSWORD\"}" > /config/credentials.json
echo /config/credentials.json
cat /config/credentials.json

exec /init.sh start starkandwayne/redis --group "${NAME:-default}" "$@"
