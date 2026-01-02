#!/usr/bin/env zsh

_fzf_git_worktrees() {
	_fzf_git_check || return
	worktree "$@"
}
