# Docker images

[![Scheduled build (Ubuntu)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml/badge.svg?event=schedule)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml)
[![On-demand build (Ubuntu)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml/badge.svg?event=workflow_dispatch)](https://github.com/catthehacker/docker_images/actions/workflows/build-ubuntu.yml)
[![Linter](https://github.com/catthehacker/docker_images/actions/workflows/lint.yml/badge.svg)](https://github.com/catthehacker/docker_images/actions/workflows/lint.yml)

## When updates will be applied to images

- A package that will be required for action(s) to work properly might be added/removed/changed
- Any maintenance that will be required due to:
  - Docker Hub
  - Quay
  - GitHub Container Registry
  - GitHub Actions
  - Act
- Performance and/or disk space improvements

## Images available

- [catthehacker/virtual-environments][catthehacker/virtual-environments] - GitHub Actions runner image containing all possible tools (image is extremely big, 20GB compressed, ~60GB extracted)
  - this image is updated manually due to amount of changes in [actions/virtual-environments][actions/virtual-environments]
    - `catthehacker/ubuntu:full-20.04`
    - `catthehacker/ubuntu:full-18.04`

    see [catthehacker/virtual-environments][catthehacker/virtual-environments] for more information

- [`/linux/ubuntu/act/`](./linux/ubuntu/scripts/act.sh) - image used in [github.com/nektos/act][nektos/act] as medium size image retaining compatibility with most actions while maintaining small size
  - `catthehacker/ubuntu:act-16.04`
  - `catthehacker/ubuntu:act-18.04`
  - `catthehacker/ubuntu:act-20.04`
  - `catthehacker/ubuntu:act-latest`
- [`/linux/ubuntu/runner/`](./linux/ubuntu/scripts/runner.sh) - `catthehacker/ubuntu:act-*` but with `runner` as user instead of `root`
  - `catthehacker/ubuntu:runner-16.04`
  - `catthehacker/ubuntu:runner-18.04`
  - `catthehacker/ubuntu:runner-20.04`
  - `catthehacker/ubuntu:runner-latest`
- [`/linux/ubuntu/js/`](./linux/ubuntu/scripts/js.sh) - `catthehacker/ubuntu:act-*` but with `js` tools installed (`yarn`, `nvm`, `node` v10/v12, `pnpm`, `grunt`, etc.)
  - `catthehacker/ubuntu:js-18.04`
  - `catthehacker/ubuntu:js-20.04`
  - `catthehacker/ubuntu:js-latest`
- [`/linux/ubuntu/rust/`](./linux/ubuntu/scripts/rust.sh) - `catthehacker/ubuntu:act-*` but with `rust` tools installed (`rustfmt`, `clippy`, `cbindgen`, etc.)
- [`/linux/ubuntu/pwsh/`](./linux/ubuntu/scripts/pwsh.sh) - `catthehacker/ubuntu:act-*` but with `pwsh` tools and modules installed
  - `catthehacker/ubuntu:pwsh-18.04`
  - `catthehacker/ubuntu:pwsh-20.04`
  - `catthehacker/ubuntu:pwsh-latest`

## [`ubuntu-16.04` will be deprecated soon](https://github.com/actions/virtual-environments/issues/3287)

## Repository contains parts of [`actions/virtual-environments`][actions/virtual-environments] which is licenced under ["MIT License"](https://github.com/actions/virtual-environments/blob/main/LICENSE)

[nektos/act]: https://github.com/nektos/act
[actions/virtual-environments]: https://github.com/actions/virtual-environments
[catthehacker/virtual-environments]: https://github.com/catthehacker/virtual-environments/tree/master/images/linux
