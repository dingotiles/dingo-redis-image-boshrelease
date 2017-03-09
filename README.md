# Dingo PostgreSQL embedded Docker images

This BOSH release is an enhancement for the [dingo-postgresql-release](https://github.com/dingotiles/dingo-postgresql-release) BOSH release. It embeds the Docker images and pre-installs them into Dingo cells. This allows Dingo PostgreSQL to be installed into data centers that do not have Internet network connectivity.

It also means that no Docker Registry is required for Dingo PostgreSQL.
