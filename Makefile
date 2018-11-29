bindir=$(DESTDIR)/usr/bin
runtests=tests/runtests
bashlibs=lib/bashlibs
script=cookie


.PHONY: install
install: install-bashlibs install-zsh $(bindir) $(script)
	cp $(script) $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

.PHONY: install-bashlibs
install-bashlibs: update-bashlibs
	make -C $(bashlibs) DESTDIR=$(DESTDIR) install

.PHONY: update-bashlibs
update-bashlibs:
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
uninstall-all: uninstall update-bashlibs
	make -C $(bashlibs) uninstall

check: $(runtests)
	./$(runtests)
