# Bratislava Github Runner

A custom image with some pre-installed dependencies for Github self-hosted runner.

## Build

You can build the image by any standard Docker image building way, such as

```sh
docker buildx build -t gh-runner:latest .
```

The image will install following packages/tools
- [envsubst](https://linux.die.net/man/1/envsubst)
- [kustomize](https://kustomize.io/)
- [yarn](https://yarnpkg.com/)

> :orange_book: Please note, that `yarn` will need **some** valid [NodeJS](https://nodejs.org/en) runtime to work. You can install such runtime, for example, by [setup-node](https://github.com/actions/setup-node) action.
