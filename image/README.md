# Dingo Redis image

This is the Docker image used in Dingo Redis tile for Pivotal Ops Manager and BOSH deployments. The primary contents are from https://github.com/starkandwayne/habitat-plans/tree/master/redis using https://habitat.sh, with an additional [`entry.sh`](https://github.com/dingotiles/dingo-redis-image-boshrelease/blob/master/image/scripts/entry.sh) to convert simple environment variables into Habitat configuration.

To build:

```
docker build -t dingotiles/dingo-redis .
```

To run:

```
docker run --name redis \
  -e REDIS_PASSWORD=secret \
  dingotiles/dingo-redis
```


Then you can see that it worked by:

```
$ docker exec redis redis-cli -a secret SET hello world
OK
$ docker exec redis redis-cli -a secret GET hello
world
```
