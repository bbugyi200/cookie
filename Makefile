bindir=$(DESTDIR)/usr/bin
runtests=tests/runtests
bashlibs=lib/bashlibs
script=cookie


.PHONY: install
install: install-gutils install-zsh $(bindir) $(script)
	cp $(script) $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

.PHONY: install-gutils
install-gutils: bashlibs
	make -C $(bashlibs) DESTDIR=$(DESTDIR) install

.PHONY: bashlibs
bashlibs:
	git submodule update --remote $(bashlibs)

.PHONY: install-zsh
install-zsh:
	@mkdir -p $(DESTDIR)/usr/share/zsh/site-functions/
	cp ./scripts/zsh/_cookie $(DESTDIR)/usr/share/zsh/site-functions/

$(bindir):
	@mkdir -p $(bindir)

uninstall:
	@rm -f $(bindir)/$(script)

.PHONY: uninstall-all
uninstall-all: uninstall bashlibs
	make -C $(bashlibs) uninstall

check: $(runtests)
	./$(runtests)
