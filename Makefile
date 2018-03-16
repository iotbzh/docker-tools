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
	@echo "* make install PREFIX=/usr"
	@echo "  changes the prefix (in this example, the scripts will be installed in /usr/bin)"

%: src/%
	@echo "Generating $@"
	@sed -e 's|@URL@|$(REMOTE)|g' -e 's|@REVISION@|$(REVISION)|g' -e 's|@VERSION@|$(VERSION)|g' $< >$@

install: $(SCRIPTS) $(DOCKERTOOLS) $(DOCKERUNIT)
	@echo "Installing scripts $(notdir $(SCRIPTS)) into $(PREFIX)/bin"
	@sudo mkdir -p $(PREFIX)/bin || { echo "Installation failed: you need to be root."; false; }
	@sudo install $(SCRIPTS) -g $$({ getent group docker || echo root; } | cut -f1 -d:) -m 750 $(PREFIX)/bin || { echo "Installation failed: you must be root."; false; }
	@echo "Installing configuration files $(notdir $(DOCKERUNIT)) $(notdir $(DOCKERTOOLS)) into /etc"
	@sudo install $(DOCKERTOOLS) -g $$({ getent group docker || echo root; } | cut -f1 -d:) -m 644 /etc 
	@sudo install $(DOCKERUNIT) -m 644 /etc/systemd/system

clean:
	@rm -vf $(SCRIPTS)
