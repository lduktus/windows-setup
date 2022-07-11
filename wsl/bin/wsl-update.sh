#!/usr/bin/env bash

# Picky bash settings
# -u undefined variable causes an error
# -o option -> pipefail will produce a pipefail if there is an error
set -uo pipefail

_check_dep(){
    if ! command -v "${1}" > /dev/null; then
        echo "${0}: command ${1} not found"
        return 1
    fi
}

# Update all system packages
_apt(){
    sudo apt update -y
    sudo apt upgrade -y
}

# Update all packages installed via pip
_pip(){
    # Really there is no pip3 update --user --all or something like that?
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
}

# Update all packages installed via pipx
_pipx(){
    pipx upgrade-all
}

# This will just update conda itself and not any environments created by conda.
_conda(){
    conda update conda
}

pkg_managers=("apt" "pip" "pipx" "conda")

# Ensure we are not in a conda environment
if ! conda info | grep -xq '^\s*active\s*environment\s*:.*None\s*$'; then
    "${0##*/}: it seems, that you are in a conda environment. This may have unwanted side effects, exiting"
    exit 1
fi

for pkg_manager in ${pkg_managers[@]}; do
    _check_dep "$pkg_manager" && _${pkg_manager}
done