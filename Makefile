.PHONY: go php all

go:
	cd go && go run .

php:
	cd php && php main.php

all: go php
