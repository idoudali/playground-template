ARG INIT_IMAGE

FROM ${INIT_IMAGE} as base

ARG BASE_SETUP_SCRIPT

# Generic dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    bash-completion \
    ca-certificates \
    curl \
    git \
    gnupg \
    gosu \
    less \
    lsb-release \
    sudo \
    screen \
    ssh \
    tmux \
    tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh  /

ENTRYPOINT ["/entrypoint.sh"]

FROM base AS dev_base

# The following scripts have been taken from the TVM build system

COPY install/ubuntu_install_core.sh /tmp/install/ubuntu_install_core.sh
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  bash /tmp/install/ubuntu_install_core.sh

COPY install/ubuntu_install_make_source.sh /tmp/install/ubuntu_install_make_source.sh
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  bash /tmp/install/ubuntu_install_make_source.sh

COPY install/ubuntu_install_cmake_source.sh /tmp/install/ubuntu_install_cmake_source.sh
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  bash /tmp/install/ubuntu_install_cmake_source.sh

FROM dev_base AS dev

# Install github cli

RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt update \
  && apt install gh -y


ENV PATH=$PATH:/usr/local/minio-binaries/
