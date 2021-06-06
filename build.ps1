if (${env:PUSH}) {
    $push = '--push'
}

$tag = "${env:TYPE}-${env:TAG}"

docker buildx build `
    --pull `
    --no-cache `
    `
    --tag ghcr.io/${env:SLUG}:${tag} `
    --tag quay.io/${env:SLUG}:${tag} `
    --tag docker.io/${env:SLUG}:${tag} `
    `
    --build-arg NODE_VERSION=${env:NODE} `
    --build-arg IMAGE=${env:IMAGE} `
    --build-arg IMAGEOS=${env:IMAGEOS} `
    --build-arg BUILD_TAG_VERSION=${env:BUILD_TAG_VERSION} `
    --build-arg BUILD_TAG=${env:BUILD_TAG} `
    --build-arg BUILD_REF=${env:BUILD_REF} `
    --build-arg TAG=${env:FROM_TAG} `
    `
    --file ./linux/${env:IMAGE}/${env:TYPE}/Dockerfile `
    `
    $push `
    `
    --platforms ${env:PLATFORMS} `
    `
    .
