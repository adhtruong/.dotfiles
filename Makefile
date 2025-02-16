.PHONY: all
all: install-bundle link

link:
	stow --verbose --target=$$HOME -R --ignore=karabiner */
	stow --verbose --target=$$HOME -R --adopt karabiner

.PHONY: delete
delete:
	stow --verbose --target=$$HOME --delete */

.PHONY: brewfile
brewfile:
	brew bundle dump --force --no-upgrade

.PHONY: install-bundle
install-bundle:
	brew bundle --no-upgrade
