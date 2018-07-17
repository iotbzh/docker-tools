PREFIX=/usr/local

MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
SCRIPTS=$(wildcard $(MAKEFILE_DIR)/src/*)
DOCKERTOOLS=$(MAKEFILE_DIR)/conf/docker-tools.conf 
DOCKERUNIT=$(MAKEFILE_DIR)/conf/docker@.service

REMOTE=$(shell git ls-remote --get-url | head -1)
REVISION=$(shell git rev-parse --short HEAD)
VERSION=$(shell cat VERSION)

all: help

help:
	@echo "Usage (root access required):"
	@echo "* make install"
	@echo "  will install scripts in $(PREFIX)" 
	@echo "* make install DESTDIR=/ PREFIX=/usr"
	@echo "  changes the prefix (in this example, the scripts will be installed in /usr/bin)"

%: src/%
	@echo "Generating $@"
	@sed -e 's|@URL@|$(REMOTE)|g' -e 's|@REVISION@|$(REVISION)|g' -e 's|@VERSION@|$(VERSION)|g' $< >$@

install: $(SCRIPTS) $(DOCKERTOOLS) $(DOCKERUNIT)
	@echo "Installing scripts $(notdir $(SCRIPTS)) into $(DESTDIR)$(PREFIX)/bin"
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install $(SCRIPTS) -m 750 $(DESTDIR)$(PREFIX)/bin
	@echo "Installing configuration files $(notdir $(DOCKERUNIT)) $(notdir $(DOCKERTOOLS)) into $(DESTDIR)/etc"
	mkdir -p $(DESTDIR)/etc
	install $(DOCKERTOOLS)  -m 644 $(DESTDIR)/etc
	mkdir -p $(DESTDIR)/usr/lib/systemd/system
	install $(DOCKERUNIT) -m 644 $(DESTDIR)/usr/lib/systemd/system

clean:
	@rm -vf $(SCRIPTS)
