APP = bin/bareIRC
.PHONY: all run debug

all:
	@mkdir -p bin
	cd src && nasm -f elf64 irc.s -o ../bin/bareIRC.o
	ld bin/bareIRC.o -o $(APP)

run: 
	$(APP)

debug:
	@mkdir -p bin
	cd src && nasm -f elf64 -g irc.s -o ../bin/bareIRC.o
	ld bin/bareIRC.o -o $(APP)
	gdb $(APP)
