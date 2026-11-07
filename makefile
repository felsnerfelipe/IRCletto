
# this is the makefile for the IRCletto project 

APP   = ./bin/IRCletto
MAIN  = irc.s
OTHER = S_parser.s C_parser.s args.s error.s socket.s stdinout.s  
.PHONY: all run debug

all:
	@mkdir -p bin
	cd src && as $(MAIN) $(OTHER) -o ../$(APP).o
	ld $(APP).o -o $(APP)

run: all
	$(APP) $(ARGS)

debug:
	@mkdir -p bin
	cd src && as -g $(MAIN) $(OTHER) -o ../$(APP).o
	ld $(APP).o -o $(APP)	
	gdb --args $(APP) $(ARGS)
