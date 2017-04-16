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
- name: dingo-redis
- name: dingo-redis-image
  url: https://github.com/dingotiles/dingo-redis-image-release/releases/download/v${version}/dingo-redis-image-${version}.tgz
  sha1: ${image_sha1}
\`\`\`
EOF
