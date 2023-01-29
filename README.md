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

- [catthehacker/virtual-environments-fork][catthehacker/virtual-environments-fork] - GitHub Actions runner image containing all possible tools (image is extremely big, 20GB compressed, ~60GB extracted)

  - this image is updated manually due to amount of changes in [actions/virtual-environments][actions/virtual-environments]

    - `ghcr.io/catthehacker/ubuntu:full-latest`
    - `ghcr.io/catthehacker/ubuntu:full-20.04`

    see [catthehacker/virtual-environments-fork][catthehacker/virtual-environments-fork] for more information

- [`/linux/ubuntu/act`](./linux/ubuntu/scripts/act.sh) - image used in [github.com/nektos/act][nektos/act] as medium size image retaining compatibility with most actions while maintaining small size
  - `ghcr.io/catthehacker/ubuntu:act-20.04`
  - `ghcr.io/catthehacker/ubuntu:act-22.04`
  - `ghcr.io/catthehacker/ubuntu:act-latest`
- [`/linux/ubuntu/runner`](./linux/ubuntu/scripts/runner.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `runner` as user instead of `root`
  - `ghcr.io/catthehacker/ubuntu:runner-20.04`
  - `ghcr.io/catthehacker/ubuntu:runner-22.04`
  - `ghcr.io/catthehacker/ubuntu:runner-latest`
- [`/linux/ubuntu/js`](./linux/ubuntu/scripts/js.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `js` tools installed (`yarn`, `nvm`, `node` v10/v12, `pnpm`, `grunt`, etc.)
  - `ghcr.io/catthehacker/ubuntu:js-20.04`
  - `ghcr.io/catthehacker/ubuntu:js-22.04`
  - `ghcr.io/catthehacker/ubuntu:js-latest`
- [`/linux/ubuntu/rust`](./linux/ubuntu/scripts/rust.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `rust` tools installed (`rustfmt`, `clippy`, `cbindgen`, etc.)
- [`/linux/ubuntu/pwsh`](./linux/ubuntu/scripts/pwsh.sh) - `ghcr.io/catthehacker/ubuntu:act-*` but with `pwsh` tools and modules installed
  - `ghcr.io/catthehacker/ubuntu:pwsh-20.04`
  - `ghcr.io/catthehacker/ubuntu:pwsh-22.04`
  - `ghcr.io/catthehacker/ubuntu:pwsh-latest`

## [`ubuntu-18.04` has been deprecated and images for that environment will not be updated anymore](https://github.com/actions/runner-images/issues/6002)

## Repository contains parts of [`actions/virtual-environments`][actions/virtual-environments] which is licenced under ["MIT License"](https://github.com/actions/virtual-environments/blob/main/LICENSE)

[nektos/act]: https://github.com/nektos/act
[actions/virtual-environments]: https://github.com/actions/virtual-environments
[catthehacker/virtual-environments-fork]: https://github.com/catthehacker/virtual-environments-fork/tree/master/images/linux
