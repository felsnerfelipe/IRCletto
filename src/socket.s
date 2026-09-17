
; this code was written by Felsner Felipe on 2026
; this is a simple IRC application written in pure x86
; it uses linux syscalls

; this file is part of the code, it defines socket and networking functions 



CreateSocket:
; this function opens a socket

	socket 2, 1, 0               ; create AF_INET sock_stream socket
	call SocketErrorCheck

	mov [SocketFd],rax           ;store the socket's fd

	ret

ConnectToAddress:
; this function tries to connect to a server address pointed to by the sockaddr struct

	
	connect [SocketFd], sockaddr, 16  ;connect to server and call CloseIfError on error
	call ConnectErrorCheck

	write 1, StrServerConnect, 20     ;for DEBUG

	ret

ReceiveData:
; this function receives data from open server socket using recv syscall

	
	recv [SocketFd], DataBuffer, 1024, 0x40  ;receive data using recv syscall with MSG_DONTWAIT flag

	; to avoid error when recv returns -1 
	cmp rax, 0 
	jl .zero
	jb .update
	
	.update:
	
		mov [LastReadSize], rax
		ret

	.zero:

		xor rax, rax
		mov [LastReadSize], rax
		ret


ReadData:

	read [SocketFd], DataBuffer, 1024   ;receive data with read syscall
	mov [LastReadSize], rax
	call CloseIfError
	ret


WriteToServer:

	mov rax, UserBuffer               					;compare the last input char to '\n'
	add rax, [LastInputSize]
	dec rax
	
	mov dl, [rax] 										; put last char in rsi
	
	cmp dl, 10
	je .write
	jne .notWrite
	
	.write:
		
		write [SocketFd], UserBuffer, [LastInputSize] 	; write whole buffer to server
		call WriteErrorCheck

		write 1, StrSentThis, 20 						;for DEBUG
		write 1, UserBuffer, [LastInputSize]

		xor rax, rax                                    ;zero LastInputSize
		mov [LastInputSize], rax
		
		ret
		
	.notWrite:
		
		ret  											; do nothing
	

CloseSocket:

	;close socketFd
	close [SocketFd]

	write 1, StrClosedSocket, 20

	ret 
