FROM ghcr.io/actions/actions-runner:2.328.0 AS prod

USER root

# installing prerequisities needed for bratiska-cli (and sometimes npm build) - yarn, kustomize, envsubst and build-essential
RUN mkdir -p /home/runner/.local/bin/ \
  && apt-get update \
  # needed for make / g++, which is sometimes needed in npm build
  && apt-get install -y --no-install-recommends --fix-missing build-essential \
  # install envsubst
  && apt-get install gettext-base \
  # install yarn and make it executable command
  && curl -fsSL -o /home/runner/.local/bin/yarn https://github.com/yarnpkg/yarn/releases/download/v1.22.19/yarn-1.22.19.js \
  && chmod +x /home/runner/.local/bin/yarn \
  # install kustomize and make it executable command
  && curl -fsSL -o /home/runner/install_kustomize.sh "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" \
  && bash /home/runner/install_kustomize.sh /home/runner/.local/bin \
  # clean up apt cache and installation scripts
  && rm /home/runner/install_kustomize.sh \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists/* \
  # fix ownership of local bin directory to runner user
  && chown -R runner:runner /home/runner/.local

# update path with local bin directory
ENV PATH="${PATH}:/home/runner/.local/bin"

USER runner

