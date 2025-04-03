CC = gcc
CFLAGS = -std=c99 -Wall -O2
TARGET = scheduler2

all: $(TARGET)

$(TARGET): scheduler2.c
	$(CC) $(CFLAGS) -o $(TARGET) scheduler3.c

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
