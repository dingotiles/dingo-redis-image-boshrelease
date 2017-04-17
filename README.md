# Dingo Redis embedded Docker images

This BOSH release embeds a Docker image and pre-installs them into VMs running docker daemon. This allows Dingo Redis to be installed into data centers that do not have Internet network connectivity, and means that no Docker Registry is required for Dingo Redis.

From the docker-boshrelease project:

```
bosh2 -d docker-broker deploy manifests/broker/docker-broker.yml \
  --vars-store tmp/creds.yml \
  -o ../dingo-redis-image-boshrelease/manifests/op-dingo-redis.yml
```

From the docker-broker-deployment project:

```
bosh2 -d docker-broker deploy docker-broker.yml \
  --vars-store tmp/creds.yml \
  -o ../dingo-redis-image-boshrelease/manifests/op-dingo-redis.yml
```
