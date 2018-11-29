bindir=$(DESTDIR)/usr/bin
runtests=tests/runtests
script=cookie


.PHONY: install
install: install-gutils install-zsh $(bindir) $(script)
	cp $(script) $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

.PHONY: install-gutils
install-gutils: clean
ifeq (,$(wildcard /usr/bin/gutils.sh))
	git clone https://github.com/bbugyi200/bashlibs
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

.PHONY: install-zsh
install-zsh:
	@mkdir -p $(DESTDIR)/usr/share/zsh/site-functions/
	cp ./scripts/zsh/_cookie $(DESTDIR)/usr/share/zsh/site-functions/

$(bindir):
	@mkdir -p $(bindir)

uninstall:
	@rm -f $(bindir)/$(script)

.PHONY: uninstall-all
uninstall-all: uninstall clean
	git clone https://github.com/bbugyi200/bashlibs
	make -C bashlibs uninstall

.PHONY: clean
clean:
	@sudo rm -rf bashlibs

check: $(runtests)
	./$(runtests)
