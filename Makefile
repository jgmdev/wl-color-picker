.PHONY: install uninstall

# Set default DESTDIR to empty
DESTDIR ?=

# Set default PREFIX
PREFIX ?= /usr

all:
	@echo "Nothing to compile. Use 'make [DESTDIR=dir] [PREFIX=dir] install' to install wl-color-picker."

install:
	@if mkdir -p "$(DESTDIR)$(PREFIX)" && [ -w "$(DESTDIR)$(PREFIX)" ]; then \
	  echo "Created installation directories"; \
	else \
		echo "Error: You do not have write permissions for '$(DESTDIR)$(PREFIX)'."; \
		exit 1; \
	fi;

	@depends="grim slurp convert zenity wl-copy notify-send"; \
	for dependency in $$(echo "$$depends" | xargs) ; do \
		echo "Checking for: $$dependency."; \
		if ! which "$$dependency" > /dev/null 2>&1 ; then \
			echo "  error: Required dependency '$$dependency' is missing."; \
			exit 1; \
		else \
			echo "  '$$dependency' found!"; \
		fi; \
	done;

	@echo

	@if [ -e "$(DESTDIR)$(PREFIX)/bin/wl-color-picker" ]; then \
		echo "Please un-install the previous version first"; \
		exit 1; \
	fi; \

	@if [ ! -d "$(DESTDIR)$(PREFIX)/bin" ]; then \
		mkdir -p "$(DESTDIR)$(PREFIX)/bin"; \
	fi;

	@if [ ! -d "$(DESTDIR)$(PREFIX)/share/applications" ]; then \
		mkdir -p "$(DESTDIR)$(PREFIX)/share/applications"; \
	fi;

	@if [ ! -d "$(DESTDIR)$(PREFIX)/share/icons" ]; then \
		mkdir -p "$(DESTDIR)$(PREFIX)/share/icons"; \
	fi;

	@if [ ! -d "$(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps" ]; then \
		mkdir -p "$(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps"; \
	fi;

	@echo 'Copying wl-color-picker'
	@echo

	cp wl-color-picker.sh "$(DESTDIR)$(PREFIX)/bin/wl-color-picker"
	cp wl-color-picker.png "$(DESTDIR)$(PREFIX)/share/icons/"
	cp wl-color-picker.svg "$(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/"
	cp wl-color-picker.desktop "$(DESTDIR)$(PREFIX)/share/applications/"

	@echo
	@echo 'Done!'

	@exit 0

uninstall:
	@if [ ! -e "$(DESTDIR)$(PREFIX)/bin/wl-color-picker" ]; then \
		echo "wl-color-picker not found, nothing to remove..."; \
		exit 1; \
	elif [ -w "$(DESTDIR)$(PREFIX)/bin/wl-color-picker" ]; then \
		echo "Install at '$(DESTDIR)$(PREFIX)' is deletable..."; \
	else \
	  echo "Install at '$(DESTDIR)$(PREFIX)' is not deletable..."; \
		echo "Please execute uninstallation as root."; \
		exit 1; \
	fi;

	@echo 'Uninstalling wl-color-picker'
	@echo

	rm "$(DESTDIR)$(PREFIX)/bin/wl-color-picker"
	rm "$(DESTDIR)$(PREFIX)/share/icons/wl-color-picker.png"
	rm "$(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/wl-color-picker.svg"
	rm "$(DESTDIR)$(PREFIX)/share/applications/wl-color-picker.desktop"

	@echo
	@echo 'Done!'
