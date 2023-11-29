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

There is also a [GitHub workflow](./.github/workflows/build.yml), that will build the image, tag it with appropriate ARC runner version and push it to Harbor.

[!NOTE]
Please note, that `yarn` will need **some** valid [NodeJS](https://nodejs.org/en) runtime to work. You can install such runtime, for example, by [setup-node](https://github.com/actions/setup-node) action.


## Deploy

To deploy/redeploy new version of this runner, you simply either - have to execute the [GitHub workflow](./.github/workflows/build.yml) - or, it also runs on regular basis (but sometimes GitHub disables it). If you see that it already run this week, just take the latest image from our [Harbor repository](https://harbor.bratislava.sk/harbor/projects/3/repositories/actions-runner-dind/artifacts-tab).

[!TIP]
If you decide to build image locally, tag it with latest version from this [ARC Docker repository](https://hub.docker.com/r/summerwind/actions-runner-dind/tags). The tag should be something like `vX.XXX.X-ubuntu-20.04`.

After you have a correct image tag, you just need to change [this line](https://dev.azure.com/bratislava-innovation/_git/Infrastructure?path=/clusters/master/kubectl/pipeline-runner.yml&version=GBmaster&line=39&lineEnd=40&lineStartColumn=1&lineEndColumn=1&lineStyle=plain&_a=contents) in our [Azure Infrastructure](https://dev.azure.com/bratislava-innovation/_git/Infrastructure) repository, through Pull Request. Once you merge it, automatic pipeline will run and deploy the change.
