bin=$(DESTDIR)/usr/bin
script=cookie

.PHONY: install uninstall uninstall-all

install: install-gutils $(bin) $(script)
	cp $(script) $(bin)/$(script)
	chmod +x $(bin)/$(script)

install-gutils: bashlibs/gutils.sh
ifeq (,$(wildcard /usr/lib/gutils.sh))
	make -C bashlibs DESTDIR=$(DESTDIR) install
endif

$(bin):
	@mkdir -p $(bin)

uninstall: $(bin)/$(script)
	@rm $(bin)/$(script)

uninstall-all: uninstall
	@make -C bashlibs uninstall
