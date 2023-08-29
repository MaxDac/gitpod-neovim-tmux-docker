ARG GITPOD_IMAGE=gitpod/workspace-postgres

FROM ${GITPOD_IMAGE}

ARG ASDF_VERSION=v0.12.0
ARG NEOVIM_VERSION=0.9.1
ARG TMUX_VERSION=3.3

ENV ZSH_THEME=powerlevel10k/powerlevel10k

RUN sudo apt-get update -y \
    && sudo apt-get install -y wget curl git apt-transport-https zsh \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*

USER gitpod

# ensure we use bash for all RUN commands
# use -l to use interactive login shell
# and ensure modifications to bashrc are properly sourced
SHELL ["/bin/bash", "-lc"]

# Installing asdf and dependencies
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch ${ASDF_VERSION}

RUN echo ". $HOME/.asdf/asdf.sh" >> $HOME/.bashrc; \
    echo ". $HOME/.asdf/asdf.sh" >> $HOME/.zshrc;

# Add asdf to PATH, so it can be run in this Dockerfile
ENV PATH="$PATH:$HOME/.asdf/bin"

# Add asdf shims to PATH, so installed executables can be run in this Dockerfile
ENV PATH="$PATH:$HOME/.asdf/shims"

RUN asdf plugin add neovim \
    && asdf plugin add tmux \
    && asdf install neovim ${NEOVIM_VERSION} \
    && asdf install tmux ${TMUX_VERSION} \
    && asdf global neovim ${NEOVIM_VERSION} \
    && asdf global tmux ${TMUX_VERSION}

# ZSH
RUN git clone https://github.com/MaxDac/neovim-configuration $HOME/.config/nvim; \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
    git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k; \
    wget https://gist.githubusercontent.com/MaxDac/46ca202e8456fe91cad5d3f77147ce6f/raw/f184201b0a8b4288de691c7af903239e9112f568/.zshrc -O $HOME/.zshrc; \
    wget https://gist.githubusercontent.com/MaxDac/73b2e0d201243b796cdfa5019d6ea287/raw/47c40e1fd21cc52153dd155d5df94322624582bf/.p10k.zsh -O $HOME/.p10k.zsh;

SHELL [ "zsh" ]