Deployment of Dingo Redis can now optionally include integration to SHIELD.

Add `-o manifests/operators/shield.yml` to the bosh2 deploy and it will automatically discover the `shield` deployment and link all future Dingo Redis docker containers to shield.
