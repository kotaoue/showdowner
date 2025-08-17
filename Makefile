.PHONY: go php python2 python3 rust javascript all compare

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

javascript:
	cd javascript && node main.js

all: go php python2 python3 rust javascript

compare: all
	cd compare && go run .
