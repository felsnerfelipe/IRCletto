
; this code was written by Felsner Felipe on 2026
; this is a simple IRC application written in pure x86
; it uses linux syscalls

%include "macros.s"
%include "error.s"
%include "C_parser.s"
%include "socket.s"
%include "stdinout.s"

; VARIABLES/DATA

section .data

	;/ INITILIASED DATA /

	variable     dq 0                     ; debug variable
	ipAddress    db 10, 227, 28, 30       ; the server's Ip address

	LastInputSize  dq 0                   ; size of last input done by user	

	LastReadSize    dq 0         ; size of last string read by ReadData

	BytesStdin      dq 0         ; number of available bytes in stdin

	timespec:							  ;timespec strcut (for nanosleep syscall)
		dd 5							  ;time_t     tv_sec;   /* Seconds */
		dq 0							  ;/* ... */  tv_nsec;  /* Nanoseconds [0, 999'999'999] */
		dd 0
		
	sockaddr:                             ; sockaddr struct (for connect syscall)
		dw 2                  			  ; AF_INET
	    db 0x1A, 0x0B         			  ; port 6667, network byte order 
	    db  185, 30, 166, 168 			  ; 185.30.166.168
	    times 8 db 0 		

										      ;/strings/
	StrServerConnect db 'connected to server!'; 20 bytes
	StrSentThis      db 'Sent This to server:';   "
    StrClosedSocket  db 'Closed Socket!      ';   "
    StrGoodBye       db 'GoodBye!            ';   "

	;ESCAPE CODES

	;for moving the cursor aorund a certain coordinate
	StrEscapeStart   db 0x1b,'['
	StrEscapeMiddle  db '};{'
	StrEscapeEnd     db 'B'
	StrZero          db '0'
    
    StrGoDown999Cursor  db 0x1b,'[','9','9','9','B' ; 6 bytes
    StrGoUp1Cursor   db 0x1b,'[','1','A' 			; 4 bytes
    StrNewLine       db 10
    StrGoRight999Cursor db 0x1b,'[','9','9','9','C' ; 6 bytes
    StrPosReport     db 0x1b,'[','6','n'         ; 4 bytes
    StrClearLine     db	0x1b,'[','2','K'	     ; 4 bytes
    StrClearScreen   db 0x1B, 0x5B, 0x32, 0x4A   ; 4 bytes
    StrHomePos       db 0x1b,'[H'                ; 3 bytes
    StrClearBehind   db 0x1b,'[','1','J'         ; 4 bytes
    StrStorePos      db 0x1b,' ','7'             ; 3 bytes
    StrLoadPos       db 0x1b,' ','8'             ; 3 bytes

    ;colors
    StrColorFBlack   db 0x1B,'[','3','0','m'
    StrColorFRed     db 0x1B,'[','3','1','m'
    StrColorFBGreen  db 0x1B,'[','3','2','m'
    StrColorFYellow  db 0x1B,'[','3','3','m'
    StrColorFBlue    db 0x1B,'[','3','4','m'
    StrColorFMagenta db 0x1B,'[','3','5','m'
    StrColorFCyan    db 0x1B,'[','3','6','m'
    StrColorFWhite   db 0x1B,'[','3','7','m'

	StrColorBBlack   db 0x1B,'[','4','0','m'
    StrColorBRed     db 0x1B,'[','4','1','m'
    StrColorBBGreen  db 0x1B,'[','4','2','m'
    StrColorBYellow  db 0x1B,'[','4','3','m'
    StrColorBBlue    db 0x1B,'[','4','4','m'
    StrColorBMagenta db 0x1B,'[','4','5','m'
    StrColorBCyan    db 0x1B,'[','4','6','m'
    StrColorBWhite   db 0x1B,'[','4','7','m'
    
    StrColorReset    db 0x1B,'[','0','m'

    
	  
				  
section .bss

	;/ UNITILIASED DATA /

	UserBuffer      resb 1024      ; buffer to store user input 

	temp            resq 1         ; used for general use in functions, should be initilised inside function and not reused

	argc            resq 1         ; number of arguments passed by user
	
	DataBuffer      resb 1024      ; buffer to store data received from server
	
	SocketFd        resq 0         ; the socket file descriptor

	;used by GetSizeTerminal
	PosReportBuffer resb 10        ; used for getting terminal dimensions
	FirstNumber     resb 30		   ; number string given by report
	SecondNumber    resb 3         ;               "

	OriginalTerminalSettings resb 60; settings for the terminal given by ioctl 
	TerminalSettings resb 60       ; settings for the terminal used by ioctl 



; LABELS/FUNCTIONS

section .text
global _start
		
;   / MAIN /

	_start:

		call GetSizeTerminal

		;clean terminal
		call ClearTerminal
		
		;connect to server
		call CreateSocket
		call ConnectToAddress

		;wait for the connection to be really open
		nanosleep timespec, 0

		.loop:	

			;treat user input
			call ParseInput

			;see if server sent anything
			call ReceiveData

			mov rax, [LastReadSize]
			cmp rax,0
			je .loop
			
			call PrintData
				
			jmp .loop
		
			




