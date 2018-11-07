bindir=$(prefix)/usr/bin

install: minicc
	[ -d $(bindir) ] || mkdir -p $(bindir)
	cp minicc $(bindir)/minicc
	chmod +x $(bindir)/minicc
