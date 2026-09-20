APP = bin/IRCletto
MAIN = irc.s
.PHONY: all run debug

all:
	@mkdir -p bin
	cd src && nasm -f elf64 $(MAIN) -o ../$(APP).o
	ld bin/$(APP).o -o $(APP)

run: all
	$(APP)

debug:
	@mkdir -p bin
	cd src && nasm -f elf64 -g $(MAIN) -o ../$(APP).o
	ld $(APP).o -o $(APP)
	gdb --args $(APP) $(ARGS)
