# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.224.2/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use hirsuite or bionic on local arm64/Apple Silicon): hirsute, focal, bionic
ARG VARIANT="hirsute"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends xdg-utils python3-pip

COPY library-scripts/* /tmp/library-scripts/
RUN bash /tmp/library-scripts/argo-cd.sh
RUN bash /tmp/library-scripts/kubectl-krew.sh

COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt && \
    rm -rf /tmp/pip-tmp