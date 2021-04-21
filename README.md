# Docker images

[![Build Docker image](https://github.com/CatTheHacker/docker-images/workflows/Build%20Docker%20image/badge.svg)](https://github.com/CatTheHacker/docker-images/actions?query=workflow%3A%22Build+Docker+image%22)
[![GitHub Super-Linter](https://github.com/catthehacker/docker_images/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

## When updates will be applied to images

- A package that will be required for action(s) to work properly might be added/removed/changed
- Any maintainance that will be required due to:
  - Docker Hub
  - Quay
  - GitHub Container Registry
  - GitHub Actions
  - Act
- Performance and/or disk space improvements

## Images available

- [virtual-environments][catthehacker/runner-image] - GitHub Actions runner image containing all possible tools (image is extremely big, 20GB compressed, ~60GB extracted)
  - `catthehacker/ubuntu:full-20.04` - this image is updated manually due to amount of changes in [actions/virtual-environments][actions/virtual-environments]
  - more to come...
- [`/linux/ubuntu/runner/`](./linux/ubuntu/runner/) - `catthehacker/ubuntu:act-*` but with `runner` as user instead of `root`
  - docker.io (DockerHub)
    - `catthehacker/ubuntu:runner-16.04`
    - `catthehacker/ubuntu:runner-18.04`
    - `catthehacker/ubuntu:runner-20.04`
    - `catthehacker/ubuntu:runner-latest`
- [`/linux/ubuntu/act/`](./linux/ubuntu/act/) - image used in [github.com/nektos/act](https://github.com/nektos/act) as medium size image retaining compatibility with most actions while maintaining small size
  - docker.io (DockerHub)
    - `catthehacker/ubuntu:act-16.04`
    - `catthehacker/ubuntu:act-18.04`
    - `catthehacker/ubuntu:act-20.04`
    - `catthehacker/ubuntu:act-latest`
- [`/linux/alpine/act/`](./linux/alpine/act/) - Alpine base image for `act`
  - docker.io (DockerHub)
    - `catthehacker/alpine:act`

[actions/virtual-environments]: https://github.com/actions/virtual-environments
[catthehacker/runner-image]: https://github.com/catthehacker/runner-image
