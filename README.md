# Docker images

[![Scheduled build (Ubuntu)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml/badge.svg?event=schedule)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml)
[![On-demand build (Ubuntu)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml/badge.svg?event=workflow_dispatch)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml)
[![Linter](https://github.com/catthehacker/docker_images/actions/workflows/lint.yml/badge.svg)](https://github.com/catthehacker/docker_images/actions/workflows/lint.yml)

## When updates will be applied to images

- A package that will be required for action(s) to work properly might be added/removed/changed
- Any maintenance that will be required due to:
  - GitHub Container Registry
  - GitHub Actions
  - Act
- Performance and/or disk space improvements

## Images available

- [ChristopherHX/runner-image-blobs](https://github.com/ChristopherHX/runner-image-blobs) GitHub Actions Hosted runner image copy containing almost all possible tools (image is extremely big, 20GB compressed, ~60GB extracted)
  - A tar backup of the GitHub Hosted Runners are uploaded once a week via a custom docker image upload script in runner-image-blobs repository
  - Synced by cron job `.github/workflows/copy-full-image.yml` to the following tags
  - You can verify if the Image is still updated regulary by inspecting the dates in `docker buildx imagetools inspect catthehacker/ubuntu:full-latest --format "{{ json . }}"`
    - The friendly tag name version in the output can be looked up here https://github.com/actions/runner-images/releases to find out more about the sources
  - available tags are
    - `ghcr.io/catthehacker/ubuntu:full-latest` (aka `full-22.04`)
    - `ghcr.io/catthehacker/ubuntu:full-24.04` (beta image)
    - `ghcr.io/catthehacker/ubuntu:full-22.04`

- [`/linux/ubuntu/act`](./linux/ubuntu/scripts/act.sh) - image used in [github.com/nektos/act][nektos/act] as medium size image retaining compatibility with most actions while maintaining small size
  - `ghcr.io/catthehacker/ubuntu:act-22.04`
  - `ghcr.io/catthehacker/ubuntu:act-24.04`
  - `ghcr.io/catthehacker/ubuntu:act-latest` (aka `act-22.04`)
- [`/linux/ubuntu/runner`](./linux/ubuntu/scripts/runner.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `runner` as user instead of `root`
  - `ghcr.io/catthehacker/ubuntu:runner-22.04`
  - `ghcr.io/catthehacker/ubuntu:runner-24.04`
  - `ghcr.io/catthehacker/ubuntu:runner-latest` (aka `runner-22.04`)
- [`/linux/ubuntu/js`](./linux/ubuntu/scripts/js.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `js` tools installed (`yarn`, `nvm`, `node` v16/v18, `pnpm`, `grunt`, etc.)
  - `ghcr.io/catthehacker/ubuntu:js-22.04`
  - `ghcr.io/catthehacker/ubuntu:js-24.04`
  - `ghcr.io/catthehacker/ubuntu:js-latest` (aka `js-22.04`)
- [`/linux/ubuntu/rust`](./linux/ubuntu/scripts/rust.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `rust` tools installed (`rustfmt`, `clippy`, `cbindgen`, etc.)
  - `ghcr.io/catthehacker/ubuntu:rust-22.04`
  - `ghcr.io/catthehacker/ubuntu:rust-24.04`
  - `ghcr.io/catthehacker/ubuntu:rust-latest` (aka `rust-22.04`)
- [`/linux/ubuntu/pwsh`](./linux/ubuntu/scripts/pwsh.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `pwsh` tools and modules installed
  - `ghcr.io/catthehacker/ubuntu:pwsh-22.04`
  - `ghcr.io/catthehacker/ubuntu:pwsh-24.04`
  - `ghcr.io/catthehacker/ubuntu:pwsh-latest` (aka `pwsh-22.04`)
- [`/linux/ubuntu/go`](./linux/ubuntu/scripts/go.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `go` tools installed
  - `ghcr.io/catthehacker/ubuntu:go-22.04`
  - `ghcr.io/catthehacker/ubuntu:go-24.04`
  - `ghcr.io/catthehacker/ubuntu:go-latest` (aka `go-22.04`)
- [`/linux/ubuntu/dotnet`](./linux/ubuntu/scripts/dotnet.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `.NET` tools installed
  - `ghcr.io/catthehacker/ubuntu:dotnet-22.04`
  - `ghcr.io/catthehacker/ubuntu:dotnet-24.04`
  - `ghcr.io/catthehacker/ubuntu:dotnet-latest` (aka `dotnet-22.04`)
- [`/linux/ubuntu/java-tools`](./linux/ubuntu/scripts/java-tools.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with Java tools installed
  - `ghcr.io/catthehacker/ubuntu:java-tools-22.04`
  - `ghcr.io/catthehacker/ubuntu:java-tools-24.04`
  - `ghcr.io/catthehacker/ubuntu:java-tools-latest` (aka `java-tools-22.04`)
- [`/linux/ubuntu/gh`](./linux/ubuntu/scripts/gh.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with GitHub CLI tools installed
  - `ghcr.io/catthehacker/ubuntu:gh-22.04`
  - `ghcr.io/catthehacker/ubuntu:gh-24.04`
  - `ghcr.io/catthehacker/ubuntu:gh-latest` (aka `gh-22.04`)
- [`/linux/ubuntu/custom`](./linux/ubuntu/scripts/custom.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with custom tools installed
  - `ghcr.io/catthehacker/ubuntu:custom-22.04`
  - `ghcr.io/catthehacker/ubuntu:custom-24.04`
  - `ghcr.io/catthehacker/ubuntu:custom-latest` (aka `custom-22.04`)

## [`ubuntu-20.04` has been deprecated and images for that environment will not be updated anymore](https://github.com/actions/runner-images/pull/11748)

## [`ubuntu-18.04` has been deprecated and images for that environment will not be updated anymore](https://github.com/actions/runner-images/issues/6002)

## Repository contains parts of [`actions/virtual-environments`][actions/virtual-environments] which is licenced under ["MIT License"](https://github.com/actions/virtual-environments/blob/main/LICENSE)

[nektos/act]: https://github.com/nektos/act
[actions/virtual-environments]: https://github.com/actions/virtual-environments
[catthehacker/virtual-environments-fork]: https://github.com/catthehacker/virtual-environments-fork/tree/master/images/linux
