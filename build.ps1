param(
    [Parameter(ValueFromPipeline)]
    [string]$progress,
    [Parameter(ValueFromPipeline)]
    [string]$owner = "${env:IMAGE_LABEL_OWNER}",
    [Parameter(ValueFromPipeline)]
    [string]$repository = "${env:IMAGE_LABEL_REPO}",
    [Parameter(ValueFromPipeline)]
    [string]$slug = 'catthehacker/ubuntu',
    [Parameter(ValueFromPipeline)]
    [string[]]$tags,
    [Parameter(ValueFromPipeline)]
    [string]$tag,
    [Parameter(ValueFromPipeline)]
    [string]$node = "${env:NODE}",
    [Parameter(ValueFromPipeline)]
    [string]$distro = 'ubuntu',
    [Parameter(ValueFromPipeline)]
    [string]$type = "${env:TYPE}",
    [Parameter(ValueFromPipeline)]
    [string]$runner = "${env:RUNNER}",
    [Parameter(ValueFromPipeline)]
    [string]$image = 'ubuntu',
    [Parameter(ValueFromPipeline)]
    [string]$platforms = "${env:PLATFORMS}",
    [Parameter(ValueFromPipeline)]
    [string]$build_tag = "${env:BUILD_TAG}",
    [Parameter(ValueFromPipeline)]
    [string]$build_tag_version = "${env:BUILD_TAG_VERSION}",
    [Parameter(ValueFromPipeline)]
    [string]$build_ref = "${env:BUILD_REF}",
    [Parameter(ValueFromPipeline)]
    [string]$from_image = "${env:FROM_IMAGE}",
    [Parameter(ValueFromPipeline)]
    [string]$from_tag = "${env:FROM_TAG}",
    [Parameter(ValueFromPipeline)]
    [switch]$push
)

$arguments = @(
    'buildx',
    'build'
)

$arguments += $push -eq $True ? @("--push") : @()

$arguments += $progress -ne 'plain' ? @("--progress=$progress") : @("--progress=plain")

$tags.Count -ne 0 ? ($tags | ForEach-Object { $arguments += @("--tag=$_") }) : ""

$arguments += $tag -ne '' ? @("--tag=$tag") : @()

$arguments += @(
    "--build-arg=NODE_VERSION=${node}",
    "--build-arg=DISTRO=${distro}",
    "--build-arg=TYPE=${type}",
    "--build-arg=RUNNER=${runner}",
    "--build-arg=BUILD_DATE=$((Get-Date).ToString('u'))",
    "--build-arg=BUILD_OWNER=${owner}",
    "--build-arg=BUILD_OWNER_MAIL=${owner}",
    "--build-arg=BUILD_REPO=${repository}",
    "--build-arg=BUILD_TAG=${build_tag}",
    "--build-arg=BUILD_TAG_VERSION=${build_tag_version}",
    "--build-arg=BUILD_REF=${build_ref}",
    "--build-arg=FROM_IMAGE=${from_image}",
    "--build-arg=FROM_TAG=${from_tag}",
    "--file=./linux/${image}/Dockerfile",
    "--platform=${platforms}",
    '.'
)

& (Get-Command 'docker').source $arguments
