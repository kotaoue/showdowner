.PHONY: go php python2 python3 rust javascript typescript java kotlin cpp ruby c csharp swift dart scala julia all compare

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

typescript:
	cd typescript && npm run start

java:
	cd java && mvn compile exec:java

kotlin:
	cd kotlin && gradle run

cpp:
	cd cpp && mkdir -p build && cd build && cmake .. && make && ./benchmark

ruby:
	cd ruby && ruby main.rb

c:
	cd c && make && ./benchmark

csharp:
	cd csharp && dotnet run --configuration Release

swift:
	cd swift && swift run -c release

dart:
	cd dart && dart run bin/main.dart

scala:
	cd scala && sbt run

julia:
	cd julia && julia main.jl

all: go php python3 rust javascript typescript java kotlin cpp ruby c csharp swift dart scala julia

compare: all
	cd compare && go run .
