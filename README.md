# Dingo Redis embedded Docker images

This BOSH release embeds a Docker image and pre-installs them into VMs running docker daemon. This allows Dingo Redis to be installed into data centers that do not have Internet network connectivity, and means that no Docker Registry is required for Dingo Redis.

## Installation

### Preparation

```
git submodule update --init
export BOSH_ENVIRONMENT=<url/alias>
export BOSH_DEPLOYMENT=dingo-redis
```

### Deployment

To deploy a service broker and 3 backend servers to host Redis:

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

### Cluster

```
$ bosh2 instances
```

Will return something similar to:

```
Instance                                          Process State  AZ  IPs
docker/11cfa8bd-1965-4f46-8547-fe6bc6b8ed97       running        z1  10.244.0.146
docker/3f684d89-8da3-46c5-9642-a8d6ba1c4075       running        z2  10.244.0.147
docker/af101924-3276-487c-aee7-9ab053381678       running        z3  10.244.0.148
sanity-test/8300bb32-8a21-41b6-a943-47e554f25339  -              z1  10.244.0.149
subway/36f068de-871d-4696-b490-6a7a4f058ca1       running        z1  10.244.0.145
```

The `subway` instance is the service broker. The `docker` instances are the backend servers that host the Redis containers.

### Sanity test

To confirm that Dingo Redis service is working, there is a built in `sanity-test` errand:

```
bosh2 run-errand sanity-test
```

This will interact directly with the service broker to provision and bind, and then set/get a value to the Redis service instance. Finally it will delete the service instance.
