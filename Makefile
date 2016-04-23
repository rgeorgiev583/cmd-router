CFLAGS = -g
TARGET_DIR = /usr/local/bin

.PHONY: all clean

all: cmdproxy

ini.o: ini.c
	$(CC) $(CFLAGS) -c $< -o $@

router.o: router.c ini.o
	$(CC) $(CFLAGS) -c $< -o $@

cmdproxy: router.o ini.o
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -D -m755 cmdproxy $(TARGET_DIR)/cmdproxy

command:
	ln -fs $(TARGET_DIR)/cmdproxy $(TARGET_DIR)/$(NAME)

remove:
	rm -f $(TARGET_DIR)/cmdproxy

clean:
	rm -f cmdproxy router.o ini.o
