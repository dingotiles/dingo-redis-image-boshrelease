This folder is deliberately empty.

This allows `packages/dingotiles_dingo_redis_image/pre_packaging` to either:

* use `image-cache/image.tgz` if it already exists (via CI pipeline resource); else
* `docker save` the image into `image-cache/image.tgz`
