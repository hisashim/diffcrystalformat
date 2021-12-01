all: checkall build

build: src/diff_crystal_format.cr
	mkdir -p bin
	crystal build --release -o bin/diff_crystal_format $<

spec:
	crystal spec

check: spec

formatcheck:
	crystal tool format --check

format:
	crystal tool format

checkall: formatcheck check

clean:
	rm -fr bin/

.PHONY: all build spec check formatcheck format checkall clean
