#!/bin/bash

set -e

NOTES=$PWD/release-notes

version=$(cat version/number)

echo v${version} > $NOTES/release-name
image_sha1=$(sha1sum final-release-tarball/*.tgz | head -n1 | awk '{print $1}')

cat > $NOTES/notes.md <<EOF
## Add to deployment manifest

\`\`\`yaml
releases:
- name: dingo-postgresql
- name: dingo-postgresql-image
  url: https://github.com/dingotiles/dingo-postgresql-image-release/releases/download/v${version}/dingo-postgresql-image-${version}.tgz
  sha1: ${image_sha1}
\`\`\`
EOF
