bindir=$(DESTDIR)/usr/bin
runtests=test_cookie.sh
script=cookie

.PHONY: install
install: install-gutils $(bindir) $(script)
	cp $(script) $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

.PHONY: install-gutils
install-gutils:
ifeq (,$(wildcard /usr/bin/gutils.sh))
	git clone https://github.com/bbugyi200/bashlibs
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

$(bindir):
	@mkdir -p $(bindir)

uninstall: $(bindir)/$(script)
	@rm $(bindir)/$(script)

.PHONY: uninstall-all
uninstall-all: uninstall
	@make -C bashlibs uninstall

check: $(runtests)
	./$(runtests)
