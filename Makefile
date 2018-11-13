bin=$(DESTDIR)/usr/bin
script=cookie

.PHONY: install uninstall uninstall-all

install: install-gutils $(bin) $(script)
	cp $(script) $(bin)/$(script)
	chmod +x $(bin)/$(script)

install-gutils:
ifeq (,$(wildcard /usr/bin/gutils.sh))
	git clone https://github.com/bbugyi200/bashlibs
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

$(bin):
	@mkdir -p $(bin)

uninstall: $(bin)/$(script)
	@rm $(bin)/$(script)

uninstall-all: uninstall
	@make -C bashlibs uninstall
