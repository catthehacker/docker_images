#!/bin/sh

docker buildx build \
  --push \
  --progress=plain \
  --tag="ghcr.io/${SLUG}:${TAG}" \
  --build-arg="NODE_VERSION=${NODE}" \
  --build-arg="DISTRO=${DISTRO}" \
  --build-arg="TYPE=${TYPE}" \
  --build-arg="RUNNER=${RUNNER}" \
  --build-arg="BUILD_TAG_VERSION=${BUILD_TAG_VERSION}" \
  --build-arg="BUILD_TAG=${BUILD_TAG}" \
  --build-arg="BUILD_REF=${BUILD_REF}" \
  --build-arg="FROM_IMAGE=${FROM_IMAGE}" \
  --build-arg="FROM_TAG=${FROM_TAG}" \
  --file="./linux/${DISTRO}/Dockerfile" \
  --platform="${PLATFORMS}" \
  .
