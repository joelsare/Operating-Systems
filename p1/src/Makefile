CC     = gcc
CFLAGS = -Wall

all : myshell

debug: CFLAGS += -DDEBUG -g
debug: myshell

myshell : myshell.c
	$(CC) $(CFLAGS) -lm -o myshell myshell.c
	
clean :
	rm -f myshell *.o
