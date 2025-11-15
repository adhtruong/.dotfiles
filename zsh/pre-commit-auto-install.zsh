# Auto-install prek hooks when entering a repo with .pre-commit-config.yaml
autoload -U add-zsh-hook

_prek_auto_install() {
	# Check if we're in a git repo and have a .pre-commit-config.yaml
	if [[ -f .pre-commit-config.yaml ]] && git rev-parse --git-dir &>/dev/null; then
		# Check if hooks are already installed by looking for pre-commit hook
		if [[ ! -f .git/hooks/pre-commit ]] || ! grep -q "prek" .git/hooks/pre-commit 2>/dev/null; then
			echo "📦 Auto-installing prek hooks..."
			prek install --install-hooks &>/dev/null
		fi
	fi
}

add-zsh-hook chpwd _prek_auto_install

# Run once on shell startup for current directory
_prek_auto_install
