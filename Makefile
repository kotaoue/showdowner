.PHONY: go php python2 python3 all compare

go:
	cd go && go run .

php:
	cd php && php main.php

python2:
	cd python2 && python2 main.py

python3:
	cd python3 && python3 main.py

all: go php python2 python3

compare: all
	cd compare && go run .
