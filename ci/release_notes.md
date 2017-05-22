v1.2.0 did not include the new docker image that should enable SHIELD integration. Instead of packaging the docker image that was tested by `testflight` CI job, it bundled the previous docker image.

This release splits out `manifests/operators/shield.yml` into two alternate operators for enabling SHIELD integration:

* `manifests/operators/shield-linked.yml` - look up SHIELD Daemon credentials via BOSH links
* `manifests/operators/shield-endpoint.yml` - provide variables to describe the SHIELD Daemon endpoint and API key

This release also introduces initial iteration of a `disaster-recovery` errand. This adds some `cf.*` property requirements to the `shield-*.yml` files.
