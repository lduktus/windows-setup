#!/usr/bin/env bash

# duktus 2022

# -e exit on error
# -u undefined variable causes an error
# -o option -> pipefail will produce a pipefail if there is an error
# -x print trace for easier debugging
set -euxo pipefail

if [ "$(whoami)" = 'root' ]; then
  echo "${0}: don't run this script as root"
fi


_update_packages(){
  sudo add-apt-repository ppa:neovim-ppa/unstable \
    && sudo apt update -y \
    && sudo apt upgrade -y \
    && return 0
    return 1
}

_install_packages(){
  sudo apt install --no-install-suggests -y \
        git \
        fish \
        tmux \
        neovim \
        fzf \
        ripgrep \
	      fd-find \
        exa \
        direnv \
        bat \
        tree \
        stow \
        git-hub \
        tig \
        nnn \
        p7zip-full \
        unzip \
        podman \
        podman-docker \
        pandoc \
        pandoc-citeproc \
        ffmpeg \
    && return 0
    return 1
}

_setup_python(){
    sudo apt install -y \
        python3-pip \
        python3-venv \
    && pip3 install --user pipx \
    && pip3 install --user git+https://github.com/cpbotha/xdg-open-wsl.git \
    && ${HOME}/.local/bin/pipx install yt-dlp \
    && ${HOME}/.local/bin/pipx install podman-compose \
    && return 0
    return 1
}

HUSHLOGIN="${HOME}/.hushlogin"
[ ! -e "$HUSHLOGIN" ] && touch "$HUSHLOGIN"


if [ -n "$WSL_DISTRO_NAME" ]; then
    case "$WSL_DISTRO_NAME" in
        Ubuntu*)
            _update_packages \
            && _install_packages \
            && _setup_python \
            ;;
        *)
            echo "${0}: This script has only been tested with Ubuntu, exiting"
            exit 1
            ;;
    esac
else
    echo "${0}: This script has only been tested with WSL 2, exiting..."
    exit 1
fi
