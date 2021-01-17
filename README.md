# Docker images

![Daily build](https://github.com/CatTheHacker/docker-images/workflows/Daily%20build/badge.svg)

- `\linux\ubuntu\runner\Dockerfile` - used as base image for [github.com/catthehacker/act](https://github.com/catthehacker/act)
  - ghcr.io (GitHub Container Registry)
    - `ghcr.io/catthehacker/ubuntu:runner-16.04`
    - `ghcr.io/catthehacker/ubuntu:runner-18.04`
    - `ghcr.io/catthehacker/ubuntu:runner-20.04`
    - `ghcr.io/catthehacker/ubuntu:runner-latest`
- `\linux\ubuntu\act\Dockerfile` - proposal for [github.com/nektos/act](https://github.com/nektos/act) as base image before support for above image is implemented
  - ghcr.io (GitHub Container Registry)
    - `ghcr.io/catthehacker/ubuntu:act-16.04`
    - `ghcr.io/catthehacker/ubuntu:act-18.04`
    - `ghcr.io/catthehacker/ubuntu:act-20.04`
    - `ghcr.io/catthehacker/ubuntu:act-latest`
