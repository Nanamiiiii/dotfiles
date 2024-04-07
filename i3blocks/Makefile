CC=gcc
CFLAGS=-g -Wall -Werror -O2 -std=c11 -Wno-format-truncation
LDLIBS=
TARGETS=bandwidth memory

.PHONY: all
all: $(TARGETS)

bandwidth: bandwidth.c
	$(CC) $^ $(CFLAGS) -o $@	

memory: memory.c
	$(CC) $^ $(CFLAGS) -o $@

