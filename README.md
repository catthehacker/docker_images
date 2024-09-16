# MOD

This is a modified version of the docker generation scripts, since I wanted to use a runner with the gcc arm compiler, which isn't available as apt package anymore and the original source that uses it hasn't updated their scripts and toolchain for a while.


I'm keeping the rest of the original README for now.

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
    - `ghcr.io/catthehacker/ubuntu:full-20.04` (Updated as long ubuntu-20.04 free public GitHub Hosted Runners are available)

- [`/linux/ubuntu/act`](./linux/ubuntu/scripts/act.sh) - image used in [github.com/nektos/act][nektos/act] as medium size image retaining compatibility with most actions while maintaining small size
  - `ghcr.io/catthehacker/ubuntu:act-20.04`
  - `ghcr.io/catthehacker/ubuntu:act-22.04`
  - `ghcr.io/catthehacker/ubuntu:act-latest`
- [`/linux/ubuntu/runner`](./linux/ubuntu/scripts/runner.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `runner` as user instead of `root`
  - `ghcr.io/catthehacker/ubuntu:runner-20.04`
  - `ghcr.io/catthehacker/ubuntu:runner-22.04`
  - `ghcr.io/catthehacker/ubuntu:runner-latest`
- [`/linux/ubuntu/js`](./linux/ubuntu/scripts/js.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `js` tools installed (`yarn`, `nvm`, `node` v16/v18, `pnpm`, `grunt`, etc.)
  - `ghcr.io/catthehacker/ubuntu:js-20.04`
  - `ghcr.io/catthehacker/ubuntu:js-22.04`
  - `ghcr.io/catthehacker/ubuntu:js-latest`
- [`/linux/ubuntu/rust`](./linux/ubuntu/scripts/rust.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `rust` tools installed (`rustfmt`, `clippy`, `cbindgen`, etc.)
  - `ghcr.io/catthehacker/ubuntu:rust-20.04`
  - `ghcr.io/catthehacker/ubuntu:rust-22.04`
  - `ghcr.io/catthehacker/ubuntu:rust-latest`
- [`/linux/ubuntu/pwsh`](./linux/ubuntu/scripts/pwsh.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `pwsh` tools and modules installed
  - `ghcr.io/catthehacker/ubuntu:pwsh-20.04`
  - `ghcr.io/catthehacker/ubuntu:pwsh-22.04`
  - `ghcr.io/catthehacker/ubuntu:pwsh-latest`

## [`ubuntu-18.04` has been deprecated and images for that environment will not be updated anymore](https://github.com/actions/runner-images/issues/6002)

## Repository contains parts of [`actions/virtual-environments`][actions/virtual-environments] which is licenced under ["MIT License"](https://github.com/actions/virtual-environments/blob/main/LICENSE)

[nektos/act]: https://github.com/nektos/act
[actions/virtual-environments]: https://github.com/actions/virtual-environments
[catthehacker/virtual-environments-fork]: https://github.com/catthehacker/virtual-environments-fork/tree/master/images/linux
