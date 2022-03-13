# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.224.2/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use hirsuite or bionic on local arm64/Apple Silicon): hirsute, focal, bionic
ARG VARIANT="hirsute"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && apt-get upgrade -y \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends xdg-utils

COPY library-scripts/argo-cd.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/argo-cd.sh