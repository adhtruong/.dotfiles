#!/usr/bin/env zsh

_fzf_git_worktrees() {
	_fzf_git_check || return
	local remove_cmd='
		[[ "$(pwd)" == {1}* ]] && cd "$(git worktree list | head -1 | awk '\''{print $1}'\'')";
		git worktree remove -f {1};
		git delete-squashed >/dev/null;
		tmux-clean >/dev/null;
		git worktree list
	'
	git worktree list | _fzf_git_fzf \
		--border-label '🌴 Worktrees ' \
		--header 'CTRL-X (remove worktree) : CTRL+A (add) : ENTER (open sesh)' \
		--bind "ctrl-x:reload($remove_cmd)" \
		--bind 'ctrl-a:reload(git-worktree-add {q} >/dev/null 2>&1; git worktree list)' \
		--bind 'enter:become(sesh connect {1})' \
		--preview "
      git -c color.status=$(__fzf_git_color .) -C {1} status --short --branch
      echo
      git log --oneline --graph --date=short --color=$(__fzf_git_color .) --pretty='format:%C(auto)%cd %h%d %s' {2} --
    " "$@"
}
