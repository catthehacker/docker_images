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

function exec() {
    $path, $myargs = $args
    $proc=Start-Process -Wait -PassThru -FilePath $path -Args $myargs
    if($proc.ExitCode -ne 0) {
    throw "$args failed with exit code $proc.ExitCode"
    }
}
function exec_out() {
    $path, $myargs = $args
    $stdout = "$(& "$path" $myargs)"
    if($LASTEXITCODE -ne 0) {
    throw "$args failed with exit code $LASTEXITCODE, error: $stdout"
    }
    return "$stdout"
}

$manifest = "$(New-Guid)-manifest:latest"

exec buildah manifest create "$manifest"

ForEach($platform in $platforms.Split(",")) {
    $intermediatetag = "$(New-Guid)-intermediate:latest"

    $arguments = @(
        "--tag=${intermediatetag}",
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
        "--platform=${platform}",
        '.'
    )

    exec buildah build --format=docker $arguments
    $containerName = New-Guid
    exec buildah from --format=docker --name "$containerName-container" --platform "${platform}" "$intermediatetag"
    $containerpath = exec_out buildah mount "$containerName-container"
    $envfileContent = Get-Content "$containerpath/etc/environment"
    $envs = @()
    ForEach($envline in $envfileContent) {
        $envs += "--env","$envline"
    }
    exec buildah config $envs "$containerName-container"
    exec buildah unmount "$containerName-container"
    exec buildah commit --format=docker "$containerName-container" "$containerName-image"
    exec buildah manifest add "$manifest" "$containerName-image"
}

if($push -eq $true) {
   ForEach($t in ($tags + ($tag -ne '' ? @("$tag") : @()))) {
       exec buildah manifest push --all "$manifest" "docker://$t"
   }
}
