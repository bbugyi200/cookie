.DEFAULT_GOAL := help

PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin

bindir=$(DESTDIR)/$(BINDIR)
runtests=tests/runtests
bashlibs=lib/bashlibs
project=cookie

define update-bashlibs
	git submodule update --init
	git submodule update --remote $(bashlibs)
endef


.PHONY: help
help:  ## Print this message.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: install
install: install-bashlibs install-zsh $(bindir) $(project) ## Install cookie.
	cp $(project) $(bindir)/$(project)
	chmod +x $(bindir)/$(project)

.PHONY: install-bashlibs
install-bashlibs:  ## Install the bashlibs library.
ifeq (,$(wildcard /usr/bin/gutils.sh))
	$(call update-bashlibs)
	$(MAKE) -C $(bashlibs) install
endif

.PHONY: install-zsh
install-zsh: ## Install ZSH completion function.
	@mkdir -p $(DESTDIR)/$(PREFIX)/share/zsh/site-functions/
	cp ./scripts/zsh/_cookie $(DESTDIR)/$(PREFIX)/share/zsh/site-functions/

$(bindir):
	@mkdir -p $(bindir)

.PHONY: uninstall
uninstall: ## Uninstall cookie.
	@rm -f $(bindir)/$(project)

.PHONY: uninstall-all
uninstall-all: uninstall ## Uninstall cookie and all of its dependencies.
	$(call update-bashlibs)
	$(MAKE) -C $(bashlibs) uninstall

.PHONY: test check
test: check
check: $(runtests) ## Run all tests.
	$(call update-bashlibs)
	./$(runtests)
