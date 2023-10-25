export ASDF_VERSION=v0.13.1
export NEOVIM_VERSION=0.9.4
export TMUX_VERSION=3.3a
export ZSH_THEME=powerlevel10k/powerlevel10k
export ERLANG_VERSION=26.1.2
export ELIXIR_VERSION=1.15.7-otp-26
export NODEJS_VERSION=18.18.2
export ZSH_THEME=powerlevel10k/powerlevel10k
export KERL_BUILD_DOCS=yes

sudo apt-get update -y \
    && sudo apt-get install -y wget curl git apt-transport-https zsh libevent-dev ncurses-dev build-essential bison pkg-config \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch ${ASDF_VERSION}

echo ". $HOME/.asdf/asdf.sh" >> $HOME/.bashrc; \
    echo ". $HOME/.asdf/asdf.sh" >> $HOME/.zshrc;

source .bashrc

asdf plugin add neovim \
    && asdf plugin add tmux \
    && asdf install neovim ${NEOVIM_VERSION} \
    && asdf install tmux ${TMUX_VERSION} \
    && asdf global neovim ${NEOVIM_VERSION} \
    && asdf global tmux ${TMUX_VERSION}

git clone https://github.com/MaxDac/neovim-configuration $HOME/.config/nvim; \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
    git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k; \
    wget https://gist.githubusercontent.com/MaxDac/46ca202e8456fe91cad5d3f77147ce6f/raw/8a4ea67f89d11109f23e7e0bcef5c82ef6109120/.zshrc -O $HOME/.zshrc; \
    wget https://gist.githubusercontent.com/MaxDac/73b2e0d201243b796cdfa5019d6ea287/raw/47c40e1fd21cc52153dd155d5df94322624582bf/.p10k.zsh -O $HOME/.p10k.zsh;

sudo apt-get update -y \
    && sudo apt-get upgrade -y \
    && sudo apt-get install -y unzip gnupg software-properties-common curl git apt-transport-https zsh libssl-dev \
    && sudo apt-get install -y build-essential autoconf m4 libncurses5-dev libncurses-dev xsltproc \
    && sudo apt-get install inotify-tools -y \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*

asdf plugin add nodejs \
    && asdf plugin add erlang \
    && asdf plugin add elixir

asdf install erlang ${ERLANG_VERSION} \
    && asdf install elixir ${ELIXIR_VERSION} \
    && asdf install nodejs ${NODEJS_VERSION}

asdf global erlang ${ERLANG_VERSION} \
    && asdf global elixir ${ELIXIR_VERSION} \
    && asdf global nodejs ${NODEJS_VERSION}

chsh -s $(which zsh)
