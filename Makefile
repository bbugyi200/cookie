bindir=$(DESTDIR)/usr/bin
project=rookiecc

install: install-gutils $(bindir) ${project}
	[ -d $(bindir) ] || mkdir -p $(bindir)
	cp ${project} $(bindir)/${project}
	chmod +x $(bindir)/${project}

install-gutils:
ifeq (,$(wildcard /usr/lib/gutils.sh))
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

$(bindir):
	[ -d $(bindir) ] || mkdir -p $(bindir)

uninstall:
	rm $(bindir)/$(project)

uninstall-all: uninstall
	make -C bashlibs uninstall
