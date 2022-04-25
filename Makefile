.PHONY: install uninstall

all:
	@echo "Nothing to compile. Use 'make [PREFIX=dir] install' to install wl-color-picker."

install:
	@if [ "$$PREFIX" = "" ]; then \
		echo "Please set the installation PREFIX directory."; \
		exit 1; \
	fi;

	@depends="grim slurp convert zenity wl-copy"; \
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

	@if [ -e "$$PREFIX/bin/wl-color-picker" ]; then \
		echo "Please un-install the previous version first"; \
		exit 1; \
	fi; \

	@if [ ! -d "$$PREFIX/bin" ]; then \
		mkdir -p "$$PREFIX/bin"; \
	fi;

	@if [ ! -d "$$PREFIX/share/applications" ]; then \
		mkdir -p "$$PREFIX/share/applications"; \
	fi;

	@if [ ! -d "$$PREFIX/share/icons" ]; then \
		mkdir -p "$$PREFIX/share/icons"; \
	fi;

	@if [ ! -d "$$PREFIX/share/icons/hicolor/scalable/apps" ]; then \
		mkdir -p "$$PREFIX/share/icons/hicolor/scalable/apps"; \
	fi;

	@echo 'Copying wl-color-picker'
	@echo

	cp wl-color-picker.sh "$$PREFIX/bin/wl-color-picker"
	cp wl-color-picker.png "$$PREFIX/share/icons/"
	cp wl-color-picker.svg "$$PREFIX/share/icons/hicolor/scalable/apps/"
	sed "s%^Exec=%Exec=$$PREFIX/bin/%" wl-color-picker.desktop > "$$PREFIX/share/applications/wl-color-picker.desktop"

	@echo
	@echo 'Done!'

	@exit 0

uninstall:
	@if [ "$$PREFIX" = "" ]; then \
		echo "Please set the installation PREFIX directory."; \
		exit 1; \
	fi;

	@echo 'Uninstalling wl-color-picker'
	@echo

	rm "$$PREFIX/bin/wl-color-picker"
	rm "$$PREFIX/share/icons/wl-color-picker.png"
	rm "$$PREFIX/share/icons/hicolor/scalable/apps/wl-color-picker.svg"
	rm "$$PREFIX/share/applications/wl-color-picker.desktop"

	@echo
	@echo 'Done!'
