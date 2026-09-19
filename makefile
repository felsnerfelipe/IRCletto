APP = bin/IRCletto
.PHONY: all run debug

all:
	@mkdir -p bin
	cd src && nasm -f elf64 irc.s -o ../bin/IRCletto.o
	ld bin/IRCletto.o -o $(APP)

run: 
	$(APP)

debug:
	@mkdir -p bin
	cd src && nasm -f elf64 -g irc.s -o ../bin/IRCletto.o
	ld bin/IRCletto.o -o $(APP)
	gdb $(APP)
