bindir=$(DESTDIR)/usr/bin
script=cookie

.PHONY: install uninstall uninstall-all

install: install-gutils $(bindir) $(script)
	cp $(script) $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

install-gutils:
ifeq (,$(wildcard /usr/bin/gutils.sh))
	git clone https://github.com/bbugyi200/bashlibs
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

$(bindir):
	@mkdir -p $(bindir)

uninstall: $(bindir)/$(script)
	@rm $(bindir)/$(script)

uninstall-all: uninstall
	@make -C bashlibs uninstall
