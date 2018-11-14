bindir=$(DESTDIR)/usr/bin
runtests=test_cookie.sh
script=cookie

.PHONY: install
install: $(script).temp $(bindir)
	mv $(script).temp $(bindir)/$(script)
	chmod +x $(bindir)/$(script)

$(script).temp: install-gutils $(script)
	sudo sed -e "/source gutils.sh/ r bashlibs/gutils.sh" -e "/source gutils.sh/d" $(script) > $(script).temp

.PHONY: install-gutils
install-gutils:
ifeq (,$(wildcard ./bashlibs/gutils.sh))
	git clone https://github.com/bbugyi200/bashlibs
endif

$(bindir):
	@mkdir -p $(bindir)

uninstall: $(bindir)/$(script)
	@rm $(bindir)/$(script)

check: $(runtests)
	./$(runtests)
