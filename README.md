# Dingo Redis embedded Docker images

This BOSH release embeds a Docker image and pre-installs them into VMs running docker daemon. This allows Dingo Redis to be installed into data centers that do not have Internet network connectivity, and means that no Docker Registry is required for Dingo Redis.

Preparation:

```
git submodule update --init
export BOSH_ENVIRONMENT=<url/alias>
export BOSH_DEPLOYMENT=dingo-redis
```

```
bosh2 deploy manifests/docker-broker.yml \
  -o manifests/operators/dingo-redis.yml
```

If your BOSH does not have Credhub/Config Server (if `bosh2 env` includes `config_server: disabled`), then include `--vars-store` to generate/store internal credentials/passwords:

```
bosh2 deploy manifests/docker-broker.yml \
  -o manifests/operators/dingo-redis.yml \
  --vars-store tmp/creds.yml
```
