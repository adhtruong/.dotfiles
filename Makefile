.PHONY: all
all: install-bundle link

link:
	stow --verbose --target=$$HOME -R */

.PHONY: delete
delete:
	stow --verbose --target=$$HOME --delete */

.PHONY: brewfile
brewfile:
	brew bundle dump --force --no-upgrade

.PHONY: install-bundle
install-bundle:
	brew bundle --no-upgrade

.PHONY: karabiner
karabiner:
	@cd karabiner/karabiner-config && npm ci && npm run build

.PHONY: lint
lint:
	pre-commit run -a
