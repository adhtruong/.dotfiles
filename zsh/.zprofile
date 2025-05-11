eval "$(/opt/homebrew/bin/brew shellenv)"
export GOPATH=$HOME/go

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(command pyenv init -)"
