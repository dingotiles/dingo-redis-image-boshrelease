# Dingo Redis image

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
