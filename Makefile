.PHONY: go php python2 all compare

go:
	cd go && go run .

php:
	cd php && php main.php

python2:
	cd python2 && python2 main.py

all: go php python2

compare: all
	cd compare && go run .
