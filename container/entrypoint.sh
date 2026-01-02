#!/bin/bash -xe

export PATH="$PATH:$(go env GOPATH)/bin"

build_headscale() {
  pushd "${HEADSCALE_SRC}" > /dev/null

  build_version="${HEADSCALE_VERSION}"
  [ -n "${build_version}" ] || build_version="HEAD"
  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd
  git submodule update --init --recursive --depth=1

  (set -x; \
    make generate \
    && make build \
    && mv headscale "${OUT_DIR}/" \
  )

  popd > /dev/null
}

(set -x; apt-get update)
(set -x; apt-get upgrade -y --only-upgrade --no-install-recommends)

(set -x; build_headscale "$@")

cat <<EOF

Successfully built headscale.
EOF
