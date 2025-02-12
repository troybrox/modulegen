install:
	mkdir -p ~/.modulegen
	swift build -c release
	install .build/release/modulegen /usr/local/bin/modulegen

uninstall:
	rm -r ~/.modulegen
	rm /usr/local/bin/modulegen

