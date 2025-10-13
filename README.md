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

## Automated Updates

This repository includes an automated workflow that checks for newer GitHub Actions runner versions and creates pull requests when updates are available.

### Setup

1. **Slack Notifications (Optional)**: To receive Slack notifications when updates are available:

   - Create a Slack app and obtain a bot token with `chat:write` scope
   - Add the bot token as a repository secret named `SLACK_BOT_TOKEN`
   - The workflow will send notifications to the `#donovallo` channel

2. **Workflow Schedule**: The update check runs every Monday at 9 AM UTC via the [check-runner-updates.yml](.github/workflows/check-runner-updates.yml) workflow.

### How It Works

1. The workflow fetches the latest available runner version from GitHub's Container Registry API
2. Compares it with the current version in the Dockerfile
3. If a newer version is found:
   - Creates a new branch with the updated version
   - Updates the Dockerfile with the new version
   - Creates a pull request with detailed information
   - Sends a Slack notification (if configured)
4. If no updates are needed, sends a status notification to Slack

### Manual Trigger

You can manually trigger the update check by:

- Going to the Actions tab in GitHub
- Selecting "Check Actions Runner Updates"
- Clicking "Run workflow"

> [!NOTE]
> Please note, that `yarn` will need **some** valid [NodeJS](https://nodejs.org/en) runtime to work. You can install such runtime, for example, by [setup-node](https://github.com/actions/setup-node) action.

## Deploy

To deploy/redeploy new version of this runner, you have to:

1. Execute the [GitHub workflow](./.github/workflows/build.yml). It also runs on regular basis (but sometimes GitHub disables it). If you see that it already run this week, just take the latest image from our [Harbor repository](https://harbor.bratislava.sk/harbor/projects/3/repositories/actions-runner-dind/artifacts-tab).
2. Once you have the correct image tag, you need to change [this line](https://dev.azure.com/bratislava-innovation/_git/Infrastructure?path=/clusters/master/kubectl/pipeline-runner.yml&version=GBmaster&line=39&lineEnd=40&lineStartColumn=1&lineEndColumn=1&lineStyle=plain&_a=contents) in our [Azure Infrastructure](https://dev.azure.com/bratislava-innovation/_git/Infrastructure) repository, through Pull Request.
3. Merge it, automatic pipeline will run and deploy the change.

> [!TIP]
> If you decide to build image locally, tag it with latest version from this [ARC Docker repository](https://hub.docker.com/r/summerwind/actions-runner-dind/tags). The tag should be something like `vX.XXX.X-ubuntu-20.04`.
