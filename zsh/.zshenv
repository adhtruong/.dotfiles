export GOPATH=$HOME/go
export XDG_CONFIG_HOME="$HOME/.config"

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi
