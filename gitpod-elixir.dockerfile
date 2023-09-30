ARG BASE_IMAGE=maxdac/gitpod-neovim

FROM ${BASE_IMAGE}

ARG ERLANG_VERSION=26.1.1
ARG ELIXIR_VERSION=1.15.6-otp-26
ARG NODEJS_VERSION=18.18.0

ENV ZSH_THEME=powerlevel10k/powerlevel10k
ENV KERL_BUILD_DOCS=yes

# Maybe not needed
# ENV DEBIAN_FRONTEND noninteractive

# ensure we use bash for all RUN commands
# use -l to use interactive login shell
# and ensure modifications to bashrc are properly sourced
SHELL ["/bin/bash", "-lc"]

RUN sudo apt-get update -y \
    && sudo apt-get install -y gnupg software-properties-common curl git apt-transport-https zsh \
    && sudo apt-get install -y build-essential autoconf m4 libncurses5-dev libncurses-dev xsltproc \
    && sudo apt-get install inotify-tools -y \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*

USER gitpod

# Installing dependencies with asdf
RUN asdf plugin add nodejs \
    && asdf plugin add erlang \
    && asdf plugin add elixir

RUN asdf install erlang ${ERLANG_VERSION} \
    && asdf install elixir ${ELIXIR_VERSION} \
    && asdf install nodejs ${NODEJS_VERSION}

RUN asdf global erlang ${ERLANG_VERSION} \
    && asdf global elixir ${ELIXIR_VERSION} \
    && asdf global nodejs ${NODEJS_VERSION}

USER root

# Downloading efm-langserver
RUN mkdir /temp \
    && cd /temp \
    && wget https://github.com/mattn/efm-langserver/releases/download/v0.0.48/efm-langserver_v0.0.48_linux_amd64.tar.gz \
    && tar -xzf efm-langserver_v0.0.48_linux_amd64.tar.gz \
    && cd efm-langserver_v0.0.48_linux_amd64 \
    && mv efm-langserver /usr/local/bin \
    && rm -rf /temp

USER gitpod

# Downloading efm-langserver credo configuration
RUN mkdir -p $HOME/.config/efm-langserver/ \
    && wget https://gist.githubusercontent.com/MaxDac/dc6a9a7ab1fd9b5e0772a748dbc45deb/raw/1e3adfb4feba13b97c1b2196d986998f6bc7bff2/config.yaml -O $HOME/.config/efm-langserver/config.yaml

