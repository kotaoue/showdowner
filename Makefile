.PHONY: go php python2 python3 rust all compare

go:
	cd go && go run .

php:
	cd php && php main.php

python2:
	cd python2 && python2 main.py

python3:
	cd python3 && python3 main.py

rust:
	cd rust && cargo run --release

all: go php python2 python3 rust

compare: all
	cd compare && go run .
