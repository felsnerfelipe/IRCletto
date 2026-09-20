
; this code was written by Felsner Felipe on 2026
; this is a simple IRC application written in pure x86
; it uses linux syscalls

;this file defines functions responsable for parsing and interpreting server responses


ParseServerResponse:
;main function that uses all the functions defined here to parse and treat server output

	;see if user typed anything
	call ReceiveData
	;call WriteToServer

SendResponseToServer:
; function that sends the Databuffer back to the server

	mov rax, DataBuffer               					;compare the last input char to '\n'
	add rax, [LastReadSize]
	dec rax
	
	mov dl, byte [rax]									; put last char in rsi
	
	cmp dl, 10
	je .write
	jne .notWrite
	
	.write:
		
		write [SocketFd], DataBuffer, [LastReadSize] 	; write whole buffer to server
		call WriteErrorCheck

		;for DEBUG
		write 1, StrColorFBlue, 5
		write 1, StrSentThis, 20 						
		write 1, DataBuffer, [LastReadSize]
		write 1, StrColorReset, 4

		xor rax, rax                                    ;zero LastInputSize
		mov [LastReadSize], rax
		
		ret
		
	.notWrite:
		
		ret  											; do nothing


AutoPong:
; function that reads the server's response and if it detects a ping message sends an automatic pong response

	mov rax , [LastReadSize]
	cmp rax, 0
	jg .CheckPing

	.DoNothing:
		ret

	.CheckPing:

		mov rax,[DataBuffer]  ; get the first 8 bytes from the data buffer
		
		cmp eax, 0x474E4950 ; "PING" in hexadecimal
		je .RespondPing
		.DoNothing2:
			ret

		.RespondPing:

			call PrintData ; so that the user knows a ping has been sent to them
		
			mov rax,[DataBuffer]  ; get the first 8 bytes from the data buffer

			mov rdx, 0xFFFFFF0000000000
			and rax, rdx
			mov rdx, 0x00000020474e4f50 ; "PONG " in hexadecimal
			or  rax, rdx

			mov [DataBuffer], rax

			call SendResponseToServer
			
			ret
