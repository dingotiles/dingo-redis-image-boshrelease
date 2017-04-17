# Dingo Redis embedded Docker images

This BOSH release embeds a Docker image and pre-installs them into VMs running docker daemon. This allows Dingo Redis to be installed into data centers that do not have Internet network connectivity, and means that no Docker Registry is required for Dingo Redis.

```
bosh2 deploy manifests/broker/docker-broker.yml \
  --vars-store tmp/creds.yml \
  -o manifests/broker/services/op-redis32.yml \
  -o ../dingo-redis-image-boshrelease/manifests/op-dingo-redis.yml
```
