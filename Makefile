PREFIX=/usr/local

SOURCES=$(wildcard src/*)
OUTPUTS=$(notdir $(SOURCES))

REMOTE=$(shell git ls-remote --get-url | head -1)
REVISION=$(shell git rev-parse --short HEAD)
VERSION=$(shell cat VERSION)

all: help

help:
	@echo "Usage as root:"
	@echo "* make install"
	@echo "  will install scripts in $(PREFIX)" 
	@echo "* make install PREFIX=/usr"
	@echo "  changes the prefix (in this example, the scripts will be installed in /usr/bin)"

%: src/%
	@echo "Generating $@"
	@sed -e 's|@URL@|$(REMOTE)|g' -e 's|@REVISION@|$(REVISION)|g' -e 's|@VERSION@|$(VERSION)|g' $< >$@

install: $(OUTPUTS)
	@echo "Installing scripts $(OUTPUTS) into $(PREFIX)/bin"
	@mkdir -p $(PREFIX)/bin || { echo "Installation failed: you need to be root."; false; }
	@install $(OUTPUTS) -g $$({ getent group docker || echo root; } | cut -f1 -d:) -m 750 $(PREFIX)/bin || { echo "Installation failed: you must be root."; false; }

clean:
	@rm -vf $(OUTPUTS)
