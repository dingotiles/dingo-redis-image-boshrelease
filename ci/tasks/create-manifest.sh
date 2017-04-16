#!/bin/bash

set -e -x -u

base_dir=$PWD
manifest_dir=$PWD/manifest

release_name=${release_name:-"dingo-redis-image"}
candidate_release_version=$(cat candidate-release/version)

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

bosh target ${bosh_target}

bosh upload release candidate-release/dingo-redis-image-*.tgz

cd $base_dir/dingo-redis-release-manifests
mkdir -p tmp

cat >tmp/release.yml <<YAML
---
releases:
  - name: ${release_name}
    version: ${candidate_release_version}
YAML

# versions available via inputs
boshreleases=("dingo-redis" "etcd" "simple-remote-syslog")
for boshrelease in "${boshreleases[@]}"; do
  regexp="dingo-redis-release\/${boshrelease}-(.*)\.tgz"
  file=$(ls $base_dir/dingo-redis-release/${boshrelease}*.tgz)
  if [[ $file =~ $regexp ]]; then
    release_version="${BASH_REMATCH[1]}"
  else
    echo "$file did not contain version"
    exit 1
  fi
  bosh upload release ${file}
  cat >>tmp/release.yml <<YAML
  - name: "${boshrelease}"
    version: "${release_version}"
YAML
done

if [[ "${enable_syslog}X" == "X" ]]; then
  echo "--- {}" > tmp/syslog.yml
else
  cat > tmp/syslog.yml <<EOF
properties:
  remote_syslog:
    address: ${bosh_syslog_host}
    port: ${bosh_syslog_port}
    short_hostname: true
  docker:
    log_driver: syslog
    log_options:
    - (( concat "syslog-address=udp://" properties.remote_syslog.address ":" properties.remote_syslog.port ))
    - tag="{{.Name}}"
  haproxy:
    syslog: (( concat properties.remote_syslog.address ":" properties.remote_syslog.port ))
EOF
fi

cat > tmp/docker_image.yml <<EOF
meta:
  docker_image:
    image: ${docker_image_image}
    tag: "${docker_image_tag}"
EOF

cat > tmp/backups.yml <<EOF
---
meta:
  backups:
    aws_access_key: "${aws_access_key}"
    aws_secret_key: "${aws_secret_key}"
    backups_bucket: "${backups_bucket}"
    clusterdata_bucket: "${clusterdata_bucket}"
    region: "${region}"
EOF

cat > tmp/cf.yml <<EOF
---
meta:
  cf:
    api_url: https://api.system.test-cf.snw
    skip_ssl_validation: true
    skip_ssl_verification: true
    username: admin
    password: A8tb4yRlQ3BmKmc1TQSCgiN7rAQXiQ73PkeoyI1qGTHq8y523kPZWjGyedjal6kx
properties:
  servicebroker:
    service_id: beb5973c-e1b2-11e5-a736-c7c0b526363d
EOF
cat tmp/cf.yml

services_template=templates/services-cluster-backup-s3.yml
# services_template=templates/services-cluster.yml

export DEPLOYMENT_NAME=${deployment_name}
./templates/make_manifest warden embedded \
  ${services_template} \
  templates/jobs-etcd.yml templates/integration-test.yml templates/cf.yml \
  tmp/syslog.yml tmp/docker_image.yml tmp/backups.yml \
  tmp/release.yml tmp/cf.yml

cp tmp/${DEPLOYMENT_NAME}*.yml ${manifest_dir}/manifest.yml

cat ${manifest_dir}/manifest.yml
