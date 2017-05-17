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

### Use image to test Redis

This image includes `sanity-test` command that can interact with a Redis service (for example, another running container of this image).

```
$ docker run --entrypoint '' \
  -e credentials='{"hostname":"10.0.0.0","port":40000,"password":"qwerty"}' \
  dingotiles/dingo-redis sanity-test
```

You can also easily use `sanity-test` command to self-test a running container:

```
docker run -d --name redis -p 6379:6379 -e REDIS_PASSWORD=somesecret dingotiles/dingo-redis && \
  docker exec -ti redis sanity-test
```

The output will look similar to:

```
No $credentials provided, entering self-test mode.
Sanity testing Redis with {"hosthame":"localhost","host":"localhost","port":6379,"password":"EHaDbp6TyVaF7rsI"}
set sanity-test 1
OK
get sanity-test = 1
```
