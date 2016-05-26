CFLAGS = -g
TARGET_DIR = /usr/local/bin

.PHONY: all remove clean

all: cmdproxy

ini.o: ini.c
	$(CC) $(CFLAGS) -c $< -o $@

cmdproxy.o: cmdproxy.c ini.o
	$(CC) $(CFLAGS) -c $< -o $@

cmdproxy: cmdproxy.o ini.o
	$(CC) $(CFLAGS) $^ -o $@

install:
	install -D -m755 cmdproxy $(TARGET_DIR)/cmdproxy
	install -D -m755 setup.sh $(TARGET_DIR)/cmdproxy-setup

remove:
	rm -f $(TARGET_DIR)/cmdproxy
	rm -f $(TARGET_DIR)/cmdproxy-setup

clean:
	rm -f cmdproxy cmdproxy.o ini.o
