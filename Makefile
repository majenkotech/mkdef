all:
	@echo "Nothing to make. Use 'make install' to install."

install:
	install -m 755 bin/mkdef /usr/bin
	cp -R usr/share/mkdef /usr/share
