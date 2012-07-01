clean:
	@rm -rf lib
	@rm -rf test/js-test
	@mkdir lib
	@mkdir test/js-test

build:
	@mkdir -p lib
	@coffee -j lib/jquery-keyboard.js -o lib -c src/keyboard.coffee

build-tests:
	@mkdir -p test/js-test
	@coffee -o test/js-test -c test/coffee

all: clean build build-tests


.PHONY: clean build build-tests all
