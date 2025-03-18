#!/usr/bin/env bash

set -euo pipefail

ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM_PLUGINS="$ZSH/custom/plugins"

[[ ! -d $ZSH  ]] && RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

plugins=(
    https://github.com/Aloxaf/fzf-tab
    https://github.com/zsh-users/zsh-autosuggestions
    https://github.com/zsh-users/zsh-syntax-highlighting
    https://github.com/junegunn/fzf-git.sh
)
for plugin in "${plugins[@]}"; do
  echo "Installing $plugin"
  directory="$ZSH_CUSTOM_PLUGINS/$(basename "$plugin" .git)"
  if [ -d "$directory" ]; then
    (cd "$directory" && git pull)
  else
    git clone "$plugin" "$directory"
  fi
done

zsh
