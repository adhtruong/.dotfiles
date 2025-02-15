.PHONY: all
all:
	stow --verbose --target=$$HOME -R */
	stow --verbose --target=$$HOME -R karabiner

.PHONY: delete
delete:
	stow --verbose --target=$$HOME --delete */

.PHONY: brewfile
brewfile:
	brew bundle dump --force --no-upgrade

.PHONY: install-bundle
install-bundle:
	brew bundle --no-upgrade
