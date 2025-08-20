CC = gcc
CFLAGS = -std=c99 -O3 -Wall -Wextra -DNDEBUG
SRCDIR = src
SOURCES = $(wildcard $(SRCDIR)/*.c)
TARGET = benchmark

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $^ -lm

clean:
	rm -f $(TARGET)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run