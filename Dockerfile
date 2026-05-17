ARG BASE_IMAGE=node:24
FROM ${BASE_IMAGE}

ARG TZ=UTC
ENV TZ="${TZ}"

# Install basic development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  less \
  git \
  procps \
  sudo \
  fzf \
  man-db \
  unzip \
  gnupg2 \
  gh \
  jq \
  nano \
  vim \
  tree \
  curl \
  ca-certificates \
  python3-yaml \
  libxml2-utils \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG USERNAME=node

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R ${USERNAME}:${USERNAME} /usr/local/share

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R ${USERNAME}:${USERNAME} /commandhistory

# Pre-create directories that will be needed for bind mounts
RUN mkdir -p /home/${USERNAME}/.config/opencode && \
    mkdir -p /home/${USERNAME}/.cache/opencode && \
    mkdir -p /home/${USERNAME}/.local/share/opencode && \
    mkdir -p /home/${USERNAME}/.claude && \
    mkdir -p /home/${USERNAME}/.config/gh && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Configure passwordless sudo for node user
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME} && \
  chmod 0440 /etc/sudoers.d/${USERNAME}

# Set up non-root user
USER ${USERNAME}

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=${PATH}:/usr/local/share/npm-global/bin

# Set the default editor
ENV EDITOR=vim
ENV VISUAL=vim

# Install OpenCode
RUN curl -fsSL https://opencode.ai/install | bash

WORKDIR /var/www/html

