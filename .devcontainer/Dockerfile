ARG VARIANT="bullseye"
#Build k9s
FROM golang:1.18.0-${VARIANT} AS buildk9s

WORKDIR /k9s
RUN apt-get -y install --no-install-recommends make git gcc libc-dev curl && \
    git clone https://github.com/derailed/k9s.git . && \
    make build

# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.224.2/containers/ubuntu/.devcontainer/base.Dockerfile
# [Choice] Ubuntu version (use hirsuite or bionic on local arm64/Apple Silicon): hirsute, focal, bionic
ARG VARIANT
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends xdg-utils python3-pip open-iscsi apt-transport-https ca-certificates gnupg

COPY --from=buildk9s /k9s/execs/k9s /usr/local/bin/k9s

COPY library-scripts/* /tmp/library-scripts/
RUN bash -c 'set -e; for f in /tmp/library-scripts/*.sh; do bash "$f"; done'

COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt && \
    rm -rf /tmp/pip-tmp && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/library-scripts