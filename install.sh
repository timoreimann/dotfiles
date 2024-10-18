#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

readonly SOURCE_PATH_COMMON="${HOME}/.local/share/chezmoi"
readonly SOURCE_PATH_BASE="${SOURCE_PATH_COMMON}/base"

if ! command -v brew >/dev/null 2>&1; then
    echo 'Installing brew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Make sure brew is available on the current shell.
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v chezmoi >/dev/null 2>&1; then
    echo 'Installing chezmoi...'
    brew install chezmoi
fi

if [[ ! -d "${SOURCE_PATH_BASE}" ]]; then
    if [[ -d "${SOURCE_PATH_COMMON}/.git" ]]; then
        echo "${SOURCE_PATH_COMMON} must not be an existing chezmoi source path already" >&2
        exit 1
    fi

    echo 'Initializing dotfiles...'
    chezmoi init timoreimann --source "${SOURCE_PATH_BASE}" --apply
fi