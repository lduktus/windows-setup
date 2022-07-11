#!/usr/bin/env bash

# Exit on error
# -e error
# -u undefined variable causes an error
# -o option -> pipefail will produce a pipefail if there is an error
# -x print trace for easier debugging
set -euxo pipefail

# Update system packages.
_update_packages(){
    echo "Updating packages..."
    sudo apt update -y \
    && sudo apt upgrade -y \
    && return 0
    return 1
}

# Install some basic applications.
_install_base_apps(){
    echo "Installing basic applications..."
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
        git-hub \
        tig \
        p7zip-full \
        pandoc \
        pandoc-citeproc \
        ffmpeg \
    && return 0
    return 1
}

# Install pip, venv and pipx and some packages via pipx.
# Info: xdg-open-wsl works like wsl, but with the default windows apps.
_setup_python(){
    echo "Installing python packages..."
    sudo apt install -y \
        python3-pip \
        python3-venv \
    && pip3 install --user pipx \
    && pip3 install --user git+https://github.com/cpbotha/xdg-open-wsl.git \
    && ${HOME}/.local/bin/pipx install yt-dlp \
    && return 0
    return 1
}

# Installs
# fisher: a plugin manager
# onedark-fish: a color theme
# z: a nice tool to jump to directories
_setup_fish(){
    if command -v fish > /dev/null; then
        chsh -s $(command -v fish) \
            && fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher" \
            && fish -c "fisher install rkbk60/onedark-fish" \
            && fish -c "fisher install mattgreen/lucid" \
            && fish -c "fisher install jethrokuan/z" \
            && return 0
    else
        echo "${0}: fish shell isn't available"
        return 1
    fi
    return 1
}

# Download, install and configure the latest miniconda version.
# -b will install everything unattended and it won't alter yout shell config.
# Hence this has to be done manually, e.g. conda init bash
_setup_miniconda(){
    INSTALLER=""${HOME}"/miniconda.sh"
    INSTALL_DIR="${HOME}/.miniconda"
    wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O "$INSTALLER" \
    && sh "$INSTALLER" -b -p "$INSTALL_DIR" \
    && rm "$INSTALLER" \
    && "${INSTALL_DIR}/bin/conda" config --set auto_activate_base  \
    && "${INSTALL_DIR}/bin/conda" config --add channels conda-forge \
    && "${INSTALL_DIR}/bin/conda" config --set channel_priority strict \
    && return 0
    return 1
}

# The current stable build of RStudio Server doesn't work on Ubuntu 22.
# Hence I decided to try a daily build for now...
_setup_rstudio_server(){
    URL="https://s3.amazonaws.com/rstudio-ide-build/server/jammy/amd64/rstudio-server-2022.10.0-daily-55-amd64.deb"
    INSTALLER="${HOME}/rstudio-server.deb"
    sudo apt install --no-install-suggests --no-install-recommends -y r-base libssl-dev libclang-dev libssl-dev libpq5\
        && wget "$URL" -O "$INSTALLER" \
        && sudo dpkg -i "$INSTALLER" \
        && rm "$INSTALLER" \
        && return 0
    return 1
}

# Link scripts to ~/.local/bin
# This way I can store scripts which I only want to use with this setup.
_link_files(){
    # SRC -> SOURCE
    # DST -> DESTINATION
    # Get the full path to our script, 
    # having the absolute path will help with linking and performing tests.
    SCRIPT_PATH=$(readlink -f "$0")
    # Get the directory name of the script directory,
    # by cutting everything behind the last slash.
    SRC_DIR=${SCRIPT_PATH%/*}
    SRC_BIN="${SRC_DIR}/bin"
    DST_BIN="${HOME}/.local/bin"
    if [ -d "$SRC_BIN" ]; then
        for f in "$SRC_BIN"/*; do
            # Full filename
            name="${f##*/}"
            # Cut any extension.
            # Note: this won't work with multiple extensions,
            # it will just remove the string behind the last dot with the dot.
            noext="${name%.*}"
            dst="${DST_BIN}/${noext}"
            if [ -e "$dst" ]; then
                # If our file is already linked do nothing,
                # in any other case create a backup and link our file.
                if [ "$(readlink -f ${dst})" == "$f" ]; then
                    echo "${0}: ${f} is already linked, skipping..."
                    continue
                else
                    echo "${0}: ${dst} already exists but doesn't point to ${f}" \
                        && echo "${0}: making backup and linking file, please check ${HOME}/bak" \
                        && mkdir -pv "${HOME}/bak" \
                        && mv "$dst" "${HOME}/bak" \
                        && ln -sv "$f" "$dst" \
                        && continue
                fi
            fi
            ln -sv "$f" "$dst" && continue
        done && return 0
        return 1
    fi   
}


# Run everything
if [ -n "$WSL_DISTRO_NAME" ]; then
    case "$WSL_DISTRO_NAME" in
        Ubuntu-*)
            _update_packages \
            && _install_base_apps \
            && _setup_python \
            && _setup_miniconda \
            && _setup_fish \
            && _setup_rstudio_server \
            && _link_files
            ;;
        *)
            echo "${0}: This script has only been tested with Ubuntu, exiting"
            exit 1
            ;;
    esac
else
    echo "This script has only been tested with WSL 2, exiting..."
    exit 1
fi