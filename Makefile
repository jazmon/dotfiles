.DEFAULT_GOAL:=install

PACKAGES=fish git heroku hg hyper omf zsh tmux starship ghostty

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