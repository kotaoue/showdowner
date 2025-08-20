.PHONY: go php python2 python3 rust javascript typescript java kotlin cpp ruby c csharp all compare

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
	cd kotlin && ./gradlew run

cpp:
	cd cpp && mkdir -p build && cd build && cmake .. && make && ./benchmark

ruby:
	cd ruby && ruby main.rb

c:
	cd c && make && ./benchmark

csharp:
	cd csharp && dotnet run --configuration Release

all: go php python3 rust javascript typescript java kotlin cpp ruby c csharp

compare: all
	cd compare && go run .
