ARG BASE_IMAGE=maxdac/gitpod-neovim

FROM ${BASE_IMAGE}

ARG ERLANG_VERSION=25.3.2.5
ARG ELIXIR_VERSION=1.15.4-otp-25
ARG NODEJS_VERSION=18.17.0

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

# Installing asdf
RUN asdf plugin add nodejs \
    && asdf plugin add erlang \
    && asdf plugin add elixir

RUN asdf install erlang ${ERLANG_VERSION} \
    && asdf install elixir ${ELIXIR_VERSION} \
    && asdf install nodejs ${NODEJS_VERSION}

RUN asdf global erlang ${ERLANG_VERSION} \
    && asdf global elixir ${ELIXIR_VERSION} \
    && asdf global nodejs ${NODEJS_VERSION}
