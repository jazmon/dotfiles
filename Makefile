.DEFAULT_GOAL:=install

PACKAGES=git zsh tmux starship ghostty

.PHONY: install
install:
	stow -t ~ $(PACKAGES)

.PHONY: uninstall
uninstall:
	stow -Dt ~ $(PACKAGES)

.PHONY: update
update: pull install

.PHONY: pull
pull:
	git pull