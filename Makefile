.PHONY: all
all:
	stow --verbose --target=$$HOME --restow */

.PHONY: delete
delete:
	stow --verbose --target=$$HOME --delete */

.PHONY: brewfile
brewfile:
	brew bundle dump --force

.PHONY: install-bundle
install-bundle:
	brew bundle --no-upgrade
