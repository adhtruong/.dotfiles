#!/usr/bin/env bash

brew install stow

# Shell set up
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew install tmux

# Tooling
brew install git
brew install git-lfs
brew install tree
brew install fd

brew install zoxide
brew install fzf

# Language tooling
brew install pyenv
