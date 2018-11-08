bindir=$(DESTDIR)/usr/bin
script=rookiecc

install: install-gutils $(bindir) ${script}
	[ -d $(bindir) ] || mkdir -p $(bindir)
	cp ${script} $(bindir)/${script}
	chmod +x $(bindir)/${script}

install-gutils:
ifeq (,$(wildcard /usr/lib/gutils.sh))
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

$(bindir):
	[ -d $(bindir) ] || mkdir -p $(bindir)

uninstall:
	rm $(bindir)/$(script)

uninstall-all: uninstall
	make -C bashlibs uninstall
