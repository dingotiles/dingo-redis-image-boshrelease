#!/bin/bash

set -e -x -u

release_name=${release_name:-"dingo-postgresql-image"}
manifest_dir=$PWD/manifest

dingo_postgresql_version=$(cat dingo-postgresql-release/version)

cat > ~/.bosh_config <<EOF
---
aliases:
  target:
    bosh-lite: ${bosh_target}
auth:
  ${bosh_target}:
    username: ${bosh_username}
    password: ${bosh_password}
EOF

cd boshrelease-ci
mkdir -p tmp

cat >tile/tmp/metadata/release.yml <<YAML
---
releases:
  - name: ${release_name}
    version: latest
YAML
cat >tile/tmp/metadata/other-releases.yml <<YAML
---
releases:
YAML

# versions available via inputs
boshreleases=("dingo-postgresql" "etcd" "simple-remote-syslog")
for boshrelease in "${boshreleases[@]}"; do
  regexp="${boshrelease}-(.*)\.tgz"
  file=$(ls dingo-postgresql-release/${boshrelease}*)
  if [[ $file =~ $regexp ]]; then
    release_version="${BASH_REMATCH[1]}"
  else
    echo "$file did not contain version"
    exit 1
  fi
  cat >>tile/tmp/metadata/other-releases.yml <<YAML
  - name: ${boshrelease}
    file: ${boshrelease}-${release_version}.tgz
    version: "${release_version}"
YAML
done

spruce merge tile/tmp/metadata/other-releases.yml \
  tile/tmp/metadata/other-releases.yml
