#Angeline Vu

COBJS = cmastermind.o
OBJS = mastermind.o
CSRCS = cmastermind.c mt19937.c
SRCS = mastermind.asm
LSTS = mastermind.lst
TARGETS = cmastermind mastermind

NFLAGS = -f elf32 -g -F dwarf -l
CFLAGS = -m32 -g
LDFLAGS = -no-pie

NASM = nasm
CC = gcc

all: $(TARGETS)

.PHONY: clean zip

$(OBJS): $(SRCS)
	$(NASM) $(NFLAGS) $(@:.o=.lst) $(@:.o=.asm)

mt19937.o: mt19937.c
	$(CC) $(CFLAGS) -c mt19937.c -o mt19937.o

mastermind: $(OBJS) mt19937.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(@) $(OBJS) mt19937.c

cmastermind: $(COBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(@) $(COBJS)

clean: 
	rm -f $(OBJS) $(COBJS) $(TARGETS) $(LSTS) mt19937.o

zip: 
	zip angevu_program4.zip README.txt Makefile cmastermind.c mastermind.asm mt19937.c mt19937.h

