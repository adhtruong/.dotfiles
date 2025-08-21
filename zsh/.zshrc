export PROFILING_MODE=0
if [ $PROFILING_MODE -ne 0 ]; then
	zmodload zsh/zprof
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

fpath+=~/.zfunc
autoload -Uz compinit
if [ ! -f ~/.zcompdump ] || [ "$(find ~/.zcompdump -mtime +1 2>/dev/null)" ]; then
	compinit
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	gitfast
	vi-mode
	fzf-tab
	zsh-autosuggestions
	zsh-completions
	zsh-syntax-highlighting
)

source "$ZSH"/oh-my-zsh.sh

# User configuration

zstyle ':completion:*:*:make:*' tag-order 'targets'
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

unsetopt BEEP

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

alias vim=nvim
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias tmuxroot='cd $(tmux display-message -p -F "#{session_path}")'
alias root='cd $(tmux display-message -p -F "#{session_path}")'

alias g='git'
alias gs='git status'
alias gst='git stash'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'

# Required for project level session set up
alias code='env -u TMUX -u VIRTUAL_ENV code'
alias cursor='env -u TMUX -u VIRTUAL_ENV cursor'

# Set up fzf key bindings and fuzzy completion
# shellcheck source=/dev/null
FZF_ALT_C_COMMAND='' source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height=80% --tmux 80% --ansi --border --layout=reverse --border --margin=1 --padding=1"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
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

# Note a plugin but store in to reuse scripts
# https://github.com/junegunn/fzf-git.sh/pull/59/files
# shellcheck source=/dev/null
source "$ZSH_CUSTOM"/plugins/fzf-git.sh/fzf-git.sh

eval "$(zoxide init zsh --cmd cd)"

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

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

# Create a new git worktree relative to repository root
function git_worktree_add() {
	local branch_name="$1"
	local repo_root
	repo_root=$(git rev-parse --show-toplevel)
	local worktree_path="$repo_root-features/$branch_name"

	if [[ -z "$branch_name" ]]; then
		echo "Branch name cannot be empty"
		return 1
	fi

	# Check if worktree path already exists
	if [[ -d "$worktree_path" ]]; then
		echo "Worktree directory '$worktree_path' already exists"
		return 1
	fi

	# Create the worktree
	git worktree add "$worktree_path" "$branch_name" >/dev/null 2>&1

	if [[ $? -eq 0 ]]; then
		echo "Created worktree '$branch_name' at $worktree_path"
	else
		echo "Failed to create worktree '$branch_name'"
		return 1
	fi
}

_fzf_git_worktrees() {
	_fzf_git_check || return
	git worktree list | _fzf_git_fzf \
		--border-label '🌴 Worktrees ' \
		--header 'CTRL-X (remove worktree) : CTRL-O (open) : CTRL+A (add)' \
		--bind 'ctrl-x:reload(git worktree remove {1} > /dev/null; git worktree list)' \
		--bind 'ctrl-o:execute(sesh connect {1})+abort' \
		--preview "
      git -c color.status=$(__fzf_git_color .) -C {1} status --short --branch
      echo
      git log --oneline --graph --date=short --color=$(__fzf_git_color .) --pretty='format:%C(auto)%cd %h%d %s' {2} --
    " "$@" |
		awk '{print $1}'
}

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
