.DEFAULT_GOAL := help

bindir=$(DESTDIR)/usr/bin
runtests=tests/runtests
bashlibs=lib/bashlibs
script=cookie


.PHONY: help
help:  ## Print this message.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: install
install: install-bashlibs install-zsh $(bindir) $(script) ## Install cookie.
	cp $(script) $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

.PHONY: install-bashlibs
install-bashlibs: update-bashlibs ## Install the bashlibs library.
	$(MAKE) -C $(bashlibs) DESTDIR=$(DESTDIR) install

.PHONY: update-bashlibs ## Update the bashlibs submodule.
update-bashlibs:
	@git submodule update --remote $(bashlibs)

.PHONY: install-zsh
install-zsh: ## Install ZSH completion function.
	@mkdir -p $(DESTDIR)/usr/share/zsh/site-functions/
	cp ./scripts/zsh/_cookie $(DESTDIR)/usr/share/zsh/site-functions/

$(bindir):
	@mkdir -p $(bindir)

.PHONY: uninstall
uninstall: ## Uninstall cookie.
	@rm -f $(bindir)/$(script)

.PHONY: uninstall-all
uninstall-all: uninstall update-bashlibs ## Uninstall cookie and all of its dependencies.
	$(MAKE) -C $(bashlibs) uninstall

.PHONY: test check
test: check
check: update-bashlibs $(runtests) ## Run all tests.
	./$(runtests)
