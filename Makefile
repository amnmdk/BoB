CC=gcc
CFLAGS=-Wall -O2

all: bob_server

bob_server: src/server.c
	$(CC) $(CFLAGS) -o bob_server src/server.c

clean:
	rm -f bob_server
