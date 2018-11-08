bindir=$(prefix)/usr/bin
project=rookiecc

install: ${project}
	[ -d $(bindir) ] || mkdir -p $(bindir)
	cp ${project} $(bindir)/${project}
	chmod +x $(bindir)/${project}
