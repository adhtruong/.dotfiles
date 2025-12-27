#/usr/bin/env bash
#
# Atuin + fzf integration
# Ctrl-R: fzf-powered history search using atuin database
# Ctrl-X Ctrl-A: atuin's native TUI interface
#
# Based on https://github.com/atuinsh/atuin/issues/68#issuecomment-1585444955

atuin-setup() {
  ! hash atuin && return

  bindkey '^X^A' _atuin_search_widget

  eval "$(ATUIN_NOBIND="true" atuin init zsh)"

  fzf-atuin-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

    # Common atuin search options
    # Use ASCII unit separator (US, \x1f) as delimiter - safe for commands with tabs
    local delim=$'\x1f'
    local atuin_fmt="{command}${delim}{directory}${delim}{duration}${delim}{exit}${delim}{relativetime}"
    local atuin_flags="--format \"$atuin_fmt\" --limit ${ATUIN_LIMIT:-5000} --reverse --print0"

    # Default to LOCAL (current directory) history
    selected=$(eval "atuin search $atuin_flags -c $PWD" |
      FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS \
        --read0 \
        --prompt 'LOCAL> ' \
        --header 'CTRL-A: toggle local/all | CTRL-R: toggle sort | CTRL-/: toggle preview' \
        --delimiter '$delim' \
        --with-nth 1 \
        --highlight-line \
        --preview 'echo -e \"Command:\n  {1}\n\nDirectory:\n  {2}\n\nDuration:\n  {3}\n\nExit Code:\n  {4}\n\nWhen:\n  {5}\"' \
        --preview-label 'Metadata' \
        --preview-window 'right:40%:wrap:hidden' \
        --bind 'ctrl-r:toggle-sort' \
        --bind 'ctrl-/:toggle-preview' \
        --bind 'ctrl-a:transform:[[ \$FZF_PROMPT == \"LOCAL> \" ]] &&
          echo \"change-prompt(ALL> )+reload(atuin search $atuin_flags)\" ||
          echo \"change-prompt(LOCAL> )+reload(atuin search $atuin_flags -c \$PWD)\"' \
        --bind 'ctrl-z:ignore' \
        $FZF_CTRL_R_OPTS --query=\"${LBUFFER}\" +m" fzf)

    local ret=$?
    if [ -n "$selected" ]; then
      # Extract just the command (first field before delimiter)
      # Replace buffer instead of appending
      LBUFFER="${selected%%$delim*}"
      RBUFFER=""
    fi
    zle reset-prompt
    return $ret
  }

  zle -N fzf-atuin-history-widget
  # Bind Ctrl+R in both vi insert and command modes
  bindkey -M viins '^R' fzf-atuin-history-widget
  bindkey -M vicmd '^R' fzf-atuin-history-widget
  bindkey '^R' fzf-atuin-history-widget  # Fallback for emacs mode
}

atuin-setup
