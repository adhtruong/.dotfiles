export PROFILING_MODE=0
if [ $PROFILING_MODE -ne 0 ]; then
	zmodload zsh/zprof
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

fpath+=~/.zfunc

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load ~/.zsh_plugins.txt

# User configuration

bindkey -v

# Make ESC switch to vi command mode instantly
bindkey -M viins '^[' vi-cmd-mode

# Vi mode clipboard integration
vi-yank-to-clipboard() {
	zle vi-yank
	echo -n "$CUTBUFFER" | pbcopy
}
zle -N vi-yank-to-clipboard

vi-paste-from-clipboard() {
	CUTBUFFER=$(pbpaste)
	zle vi-put-after
}
zle -N vi-paste-from-clipboard

bindkey -M vicmd 'y' vi-yank-to-clipboard
bindkey -M vicmd 'p' vi-paste-from-clipboard
bindkey -M viins '^V' vi-paste-from-clipboard

setopt glob_dots
zstyle ':completion:*:*:make:*' tag-order 'targets'
zstyle ':completion:*' ignored-patterns '.git' 'node_modules'
zstyle ':completion:*' special-dirs false
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
if [[ "${widgets[zle - keymap - select]#user:}" == "starship_zle-keymap-select" ||
	"${widgets[zle - keymap - select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
	zle -N zle-keymap-select ""
fi
eval "$(starship init zsh)"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi
export XDG_CONFIG_HOME="$HOME/.config"
unsetopt BEEP

[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

alias vim=nvim
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias tmuxroot='cd $(tmux display-message -p -F "#{session_path}")'
alias root='cd $(tmux display-message -p -F "#{session_path}")'

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'

alias g='git'
alias gs='git status'
alias gst='git stash'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gp='git push'
alias gu='git pull'
alias gd='git diff'

git() {
	if [ $# -eq 0 ]; then
		command git status
	else
		command git "$@"
	fi
}

alias lg='lazygit'
bindkey -s '^G' 'lazygit\n'

# Required for project level session set up
alias code='env -u TMUX -u VIRTUAL_ENV code'
alias cursor='env -u TMUX -u VIRTUAL_ENV cursor'

# Set up fzf key bindings and fuzzy completion
# shellcheck source=/dev/null
FZF_ALT_C_COMMAND='' source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height=80% --tmux 80% --ansi --border --layout=reverse --border --margin=1 --padding=1 \
    --bind 'ctrl-b:preview-page-up' \
    --bind 'ctrl-d:preview-page-down' \
    --bind 'ctrl-f:preview-page-down'
    --bind 'ctrl-y:execute(readlink -f {} | pbcopy)'"

export FZF_CTRL_T_COMMAND="fd --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,.venv
  --header 'CTRL-V (open) : CTRL-Y (copy)' \
  --preview 'fzf-preview {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --bind 'ctrl-y:execute(readlink -f {} | pbcopy)'
  --bind 'ctrl-v:become:nvim {+} > /dev/tty'"
bindkey "^u" kill-whole-line
bindkey "^f" forward-word

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
	fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
	fd --type=d --hidden --exclude .git . "$1"
}

zsh-defer eval "$(zoxide init zsh --cmd cd)"

if [[ $- =~ i ]] && [[ -z "$TMUX" ]]; then
	session_name="default"
	if [[ "$PWD" != "$HOME" ]]; then
		session_name=$(basename "$PWD")
	fi
	tmux new -A -s "$session_name" && exit
fi

TARGET_ENV=${VIRTUAL_ENV:-.venv}
if [[ -e "${TARGET_ENV}/bin/activate" ]]; then
	# shellcheck source=/dev/null
	source "${TARGET_ENV}/bin/activate"
fi

zsh-defer source ~/.dotfiles/zsh/fzf-git-overrides.zsh

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && (builtin cd -- "$cwd" || exit 1)
	rm -f -- "$tmp"
}

if [ $PROFILING_MODE -ne 0 ]; then
	zprof
fi
