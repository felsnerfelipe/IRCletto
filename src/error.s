
; this code was written by Felsner Felipe on 2026
; this is a simple IRC application written in pure x86
; it uses linux syscalls

; this file is part of the code, it defines error check functions

; CODE | ERROR
; -1     generic error
; -2     not able to open socket
; -3     not able to connect to server
; -4     not able to write to server


; ERROR -1
CloseIfError:
;generic error

		;compare return to 0
		cmp rax, 0 

		;if less, close socket and program
		jl .close

		ret

		.close:
		
			;close socket
			close [SocketFd]	
							
			;close the app with error
			exit -1
			
; ERROR -2
SocketErrorCheck:

		;compare return to 0
		cmp rax, 0 

		;if less, close socket and program
		jl .close

		ret

		.close:
		
			;close socket
			close [SocketFd]	
						
			;close the app with error
			exit -2

		
; ERROR -3
ConnectErrorCheck:

		;compare return to 0
		cmp rax, 0 

		;if less, close socket and program
		jl .close

		ret

		.close:
		
			;close socket
			close [SocketFd]	
						
			;close the app with error
			exit -3

; ERROR -4
WriteErrorCheck:

		;compare return to 0
		cmp rax, 0 

		;if less, close socket and program
		jl .close

		ret

		.close:
		
			;close socket
			close [SocketFd]	
						
			;close the app with error
			exit -4

