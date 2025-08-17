.PHONY: go php all compare

go:
	cd go && go run .

php:
	cd php && php main.php

all: go php

compare: all
	cd compare && go run .
