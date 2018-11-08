bindir=$(prefix)/usr/bin
project=rookiecc

install: ${project}
	make -C bashlibs prefix=$(prefix) install
	[ -d $(bindir) ] || mkdir -p $(bindir)
	cp ${project} $(bindir)/${project}
	chmod +x $(bindir)/${project}

uninstall:
	rm $(bindir)/$(project)

uninstall-all: uninstall
	make -C bashlibs uninstall
