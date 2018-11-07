bindir=$(prefix)/usr/bin

install: minicc config
	[ -d $(bindir) ] || mkdir -p $(bindir)
	cp minicc $(bindir)/minicc
	chmod +x $(bindir)/minicc
