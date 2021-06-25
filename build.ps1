param(
    $slug = 'catthehacker/ubuntu',
    $tag,
    $node = '12',
    $distro = 'ubuntu',
    $type,
    $image = 'ubuntu',
    $platforms = 'linux/amd64',
    $build_version = "master",
    $build_tag,
    $build_tag_version = "dev",
    $build_ref = 'master',
    $from_image,
    $from_tag,
    $runner
)

& (Get-Command 'docker').source @(
    'buildx',
    'build',
    '--progress=plain',
    "--tag=ghcr.io/${slug}:${tag}",
    "--tag=quay.io/${slug}:${tag}",
    "--tag=docker.io/${slug}:${tag}",
    "--build-arg=NODE_VERSION=${node}",
    "--build-arg=DISTRO=${distro}",
    "--build-arg=TYPE=${type}",
    "--build-arg=BUILD_TAG=${build_tag}",
    "--build-arg=BUILD_TAG_VERSION=${build_tag_version}",
    "--build-arg=BUILD_REF=${build_ref}",
    "--build-arg=FROM_IMAGE=${from_image}",
    "--build-arg=FROM_TAG=${from_tag}",
    "--file=./linux/${image}/Dockerfile",
    "--platform=${platforms}",
    '.'
)
