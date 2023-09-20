FROM summerwind/actions-runner-dind:ubuntu-20.04 as prod

USER root

# installing prerequisities needed for bratiska-cli - yarn, kustomize, envsubst
RUN mkdir -p ~/.local/bin/ \
 # install envsubst
 && apt-get update && apt-get install gettext-base \
 # install yarn and make it executable command
 && curl -fsSL -o ~/.local/bin/yarn https://github.com/yarnpkg/yarn/releases/download/v1.22.19/yarn-1.22.19.js \
 && chmod +x ~/.local/bin/yarn \
 # install kustomize and make it executable command
 && curl -fsSL -o ~/install_kustomize.sh "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" \
 && bash ~/install_kustomize.sh ~/.local/bin \
 # clean up apt cache and installation scripts
 && rm ~/install_kustomize.sh \
 && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# update path with yarn package installation directory
ENV PATH="${PATH}:/home/runner/.yarn/bin"

# add docker buildx BuildKit plugin
COPY --from=docker/buildx-bin:latest /buildx /usr/libexec/docker/cli-plugins/docker-buildx

USER runner

