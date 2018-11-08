bindir=$(DESTDIR)/usr/bin
script=rookiecc

.PHONY: install uninstall uninstall-all

install: install-gutils $(bindir) $(script)
	cp $(script) $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

install-gutils: bashlibs/gutils.sh
ifeq (,$(wildcard /usr/lib/gutils.sh))
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

$(bindir):
	@mkdir -p $(bindir)

uninstall: $(bindir)/$(script)
	rm $(bindir)/$(script)

uninstall-all: uninstall
	make -C bashlibs uninstall
