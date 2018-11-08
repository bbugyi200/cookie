bindir=$(DESTDIR)/usr/bin
project=rookiecc

install: ${project}
	make -C bashlibs DESTDIR=$(DESTDIR) install
	[ -d $(bindir) ] || mkdir -p $(bindir)
	cp ${project} $(bindir)/${project}
	chmod +x $(bindir)/${project}

uninstall:
	rm $(bindir)/$(project)

uninstall-all: uninstall
	make -C bashlibs uninstall
