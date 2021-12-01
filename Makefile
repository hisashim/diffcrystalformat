all: checkall build

build:
	shards build --release

depcheck:
	shards check

spec:
	crystal spec

check: spec

formatcheck:
	crystal tool format --check

format:
	crystal tool format

checkall: check formatcheck depcheck

clean:
	rm -fr bin/

.PHONY: all build spec check formatcheck format checkall clean
