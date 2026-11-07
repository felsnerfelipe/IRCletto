
.intel_syntax noprefix

# this code was written by Felsner Felipe on 2026
# this is a simple IRC application written in pure x86
# it uses linux syscalls

.import macros_GAS.s

# stdinout
.extern GetSizeTerminal
.extern ClearTerminal
.extern ReadUserInput
.extern PrintData

#error.s
.extern CloseIfError
.extern WriteErrorNoA.intress
.extern WriteErrorCheck
.extern SocketErrorCheck
.extern ConnectErrorCheck

# socket.s
.extern CreateSocket
.extern ConnectToA.intress
.extern ReceiveData
.extern ReadData
.extern CloseSocket
.extern WriteToServer

# C_parser
.extern ParseInput
.extern ParseInput
.extern FormatPRIVMSG

# S_parser
.extern ParseServerResponse
.extern AutoPong
.extern SendResponseToServer

# args.s
.extern ReadArgs
.extern PrintHelpInfo
.extern IpToAdress
.extern StrToNumber


# VARIABLES/DATA

.section .data

	#/ INITILIASED DATA /

	#/*used by args.s*/
    .global StrHelpInfo

	StrHelpInfo: .ascii "USAGE: IRCletto [OPTIONS] [SERVER ADDRESS] [SERVER PORT]\n" # 57 bytes long
	#/*used by args.s*/



	#/*used by args.S*/
    .global argc
    .global argv
    .global PointerToFunction
    .global ipnumber

	argc:         .quad 0             # number of arguments for executable
	argv:         .quad 0             # char** to argumentas
	PointerToFunction: .quad 0# used by ReadArgs to save its pointer when reading the stack
    ipnumber:     .ascii "000"
	#/*used by args.S*/



	variable:     .quad 0                     # debug variable



	#/*used by socket.s*/
    .global ipA.intress
    .global socka.intr
    .global StrServerConnect
    .global StrSentThis
    .global StrClosedSocket
    .global StrGoodBye
    .global LastInputSize
    .global LastReadSize
    .global BytesStdin


	ipAddress:    .byte 10, 227, 28, 30       # the server's Ip address
		
	sockaddr:                             # sockaddr struct (for connect syscall)
		.word 2                  			  # AF_INET
	    .byte 0x1A, 0x0B         			  # port 6667, network byte order 
	    .byte  185, 30, 166, 168 			  # 185.30.166.168
	    .quad  0 	



    StrServerConnect: .ascii "connected to server!"# 20 bytes
	StrSentThis:      .ascii "Sent This to server:"#   "
    StrClosedSocket:  .ascii "Closed Socket!      "#   "
    StrGoodBye:       .ascii "GoodBye!            "#   "
	#/*used by socket.s*/


	LastInputSize:  .quad 0                   # size of last input done by user	
	LastReadSize:    .quad 0         # size of last string read by ReadData
	BytesStdin:      .quad 0         # number of available bytes in stdin



	#/*used by irc.s*/
	timespec:							  #timespec strcut (for nanosleep syscall)
		.int 5							  #time_t     tv_sec;   /* Seconds */
		.quad 0							  #/* ... */  tv_nsec;  /* Nanoseconds [0, 999'999'999] */
		.int 0
	#/*used by irc.s*/



	#/*used by C_parser*/
    .global CurrentChannel
    .global StrPRIVMSG

	CurrentChannel: .ascii "#the-dudes               " # 25 bytes max
	StrPRIVMSG: .ascii "PRIVMSG "# 8 bytes
	#/*used by C_parser*/

	
	#/*used by stdinout.s*/	
	#ESCAPE CODES

	#for moving the cursor aorund a certain coordinate
    .global StrGoDown999Cursor
    .global StrGoUp1Cursor
    .global StrNewLine
    .global StrGoRight999Cursor

	StrEscapeStart:   .byte 0x1b,'['
	StrEscapeMiddle:  .ascii "}#{"
	StrEscapeEnd:     .byte 'B'
	StrZero:          .byte '0'
    
    StrGoDown999Cursor:  .byte 0x1b,'[','9','9','9','B' # 6 bytes
    StrGoUp1Cursor:   .byte 0x1b,'[','1','A' 			# 4 bytes
    StrNewLine:       .byte 10
    StrGoRight999Cursor: .byte 0x1b,'[','9','9','9','C' # 6 bytes
    .global StrPosReport
    StrPosReport:     .byte 0x1b,'[','6','n'         # 4 bytes
    StrClearLine:     .byte	0x1b,'[','2','K'	     # 4 bytes
    .global StrClearScreen
    StrClearScreen:   .byte 0x1B, 0x5B, 0x32, 0x4A   # 4 bytes
    StrHomePos:       .byte 0x1b,'[','H'             # 3 bytes
    StrClearBehind:   .byte 0x1b,'[','1','J'         # 4 bytes
    StrStorePos:      .byte 0x1b,' ','7'             # 3 bytes
    StrLoadPos:       .byte 0x1b,' ','8'             # 3 bytes

    #colors
    StrColorFBlack:   .byte 0x1B,'[','3','0','m'
    StrColorFRed:     .byte 0x1B,'[','3','1','m'
    StrColorFBGreen:  .byte 0x1B,'[','3','2','m'
    .global StrColorFYellow
    StrColorFYellow:  .byte 0x1B,'[','3','3','m'
    .global StrColorFBlue
    StrColorFBlue:    .byte 0x1B,'[','3','4','m'
    StrColorFMagenta: .byte 0x1B,'[','3','5','m'
    StrColorFCyan:    .byte 0x1B,'[','3','6','m'
    StrColorFWhite:   .byte 0x1B,'[','3','7','m'

	StrColorBBlack:   .byte 0x1B,'[','4','0','m'
    StrColorBRed:     .byte 0x1B,'[','4','1','m'
    StrColorBBGreen:  .byte 0x1B,'[','4','2','m'
    StrColorBYellow:  .byte 0x1B,'[','4','3','m'
    StrColorBBlue:    .byte 0x1B,'[','4','4','m'
    StrColorBMagenta: .byte 0x1B,'[','4','5','m'
    StrColorBCyan:    .byte 0x1B,'[','4','6','m'
    StrColorBWhite:   .byte 0x1B,'[','4','7','m'
    
    .global StrColorReset
    StrColorReset:    .byte 0x1B,'[','0','m'
	#/*used by stdinout.s*/
    
	  
				  
.section .bss

	#/ UNITILIASED DATA /
    .global UserBuffer
    .global temp

	UserBuffer:      .skip 1024      # buffer to store user input 

	temp:            .skip 8  # used for general use in functions, should be initilised inside function and not reused
	
    .global DataBuffer
	DataBuffer:      .skip 1024      # buffer to store data received from server
	
    .global SocketFd
	SocketFd:        .skip 8         # the socket file descriptor

	#used by GetSizeTerminal
    .global PosReportBuffer
	PosReportBuffer: .skip 10        # used for getting terminal dimensions

    .global FirstNumber
	FirstNumber:     .skip 30		   # number string given by report
    .global SecondNumber
	SecondNumber:    .skip 3         #               "

    .global OriginalTerminalSettings
	OriginalTerminalSettings: .skip 60# settings for the terminal given by ioctl 

    .global TerminalSettings
	TerminalSettings: .skip 60       # settings for the terminal used by ioctl 



# LABELS/FUNCTIONS

.section .text
.global _start
		
#   / MAIN /

	_start:

	    #call GetSizeTerminal

		#clean terminal
		call ClearTerminal

		call ReadArgs
		
		#connect to server
		call CreateSocket
		call ConnectToAddress

		#wait for the connection to be really open
		nanosleep timespec, 0

		.loop:	

			#treat user input
			call ParseInput

			#see if server sent anything
			call ReceiveData
			call AutoPong
	
			mov rax, [LastReadSize]
			cmp rax,0
			je .loop
			
			call PrintData
				
			jmp .loop
		
			




