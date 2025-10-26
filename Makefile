help: ## Display this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: install-bundle link ## Install all dependencies and link dotfiles

.PHONY: link
link: ## Link all dotfiles to home directory using GNU Stow
	stow --verbose --target=$$HOME -R */

.PHONY: delete
delete: ## Remove all dotfile links from home directory
	stow --verbose --target=$$HOME --delete */

.PHONY: brewfile
brewfile: ## Update Brewfile with currently installed packages
	brew bundle dump --force --no-upgrade
	# HACK filter out go files
	grep -v '^go ' Brewfile > Brewfile.tmp && mv Brewfile.tmp Brewfile

.PHONY: install-bundle
install-bundle: ## Install packages from Brewfile
	brew bundle --no-upgrade

.PHONY: karabiner
karabiner:
	@cd karabiner/karabiner-config && npm ci && npm run build

.PHONY: lint
lint:  ## Run pre-commit hooks on all files
	pre-commit run -a
