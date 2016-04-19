CFLAGS = -g
NAME = cmd-router

.PHONY: all clean

all: cmd-router

ini.o: ini.c
	$(CC) $(CFLAGS) -c $< -o $@

router.o: router.c ini.o
	$(CC) $(CFLAGS) -c $< -o $@

cmd-router: router.o ini.o
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -D -m755 cmd-router /usr/local/bin/$(NAME)

clean:
	rm -f cmd-router router.o ini.o
