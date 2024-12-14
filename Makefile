.PHONY=all
all:
	stow --verbose --target=$$HOME --restow */

.PHONY=delete
delete:
	stow --verbose --target=$$HOME --delete */
