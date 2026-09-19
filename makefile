APP = bin/bbIRC
.PHONY: all run debug

all:
	@mkdir -p bin
	cd src && nasm -f elf64 irc.s -o ../bin/bbIRC.o
	ld bin/bbIRC.o -o $(APP)

run: 
	$(APP)

debug:
	@mkdir -p bin
	cd src && nasm -f elf64 -g irc.s -o ../bin/bbIRC.o
	ld bin/bbIRC.o -o $(APP)
	gdb $(APP)
