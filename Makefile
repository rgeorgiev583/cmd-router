CFLAGS = -g
TARGET_DIR = /usr/local/bin

.PHONY: all clean

all: cmd-router

ini.o: ini.c
	$(CC) $(CFLAGS) -c $< -o $@

router.o: router.c ini.o
	$(CC) $(CFLAGS) -c $< -o $@

cmd-router: router.o ini.o
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -D -m755 cmd-router $(TARGET_DIR)/cmd-router

command:
	ln -fs $(TARGET_DIR)/cmd-router $(TARGET_DIR)/$(NAME)

remove:
	rm -f $(TARGET_DIR)/cmd-router

clean:
	rm -f cmd-router router.o ini.o
