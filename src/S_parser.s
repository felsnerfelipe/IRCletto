.intel_syntax noprefix

# this code was written by Felsner Felipe on 2026
# this is a simple IRC application written in pure x86
# it uses linux syscalls

#this file defines functions responsable for parsing and interpreting server responses
.section .text

.global ParseServerResponse
.global AutoPong
.global SendResponseToServer

.extern Databuffer
.extern ReceiveData
.extern LastReadSize
.extern LastInputSize
.extern SocketFd
.extern WriteErrorCheck
.extern StrColorFBlue
.extern StrSentThis
.extern StrColorReset
.extern PrintData

ParseServerResponse:
#main function that uses all the functions defined here to parse and treat server output

	#see if user typed anything
	call ReceiveData
	#call WriteToServer

SendResponseToServer:
# function that sends the Databuffer back to the server

	lea rax, [rip + DataBuffer]               					#compare the last input char to '\n'
	add rax, [LastReadSize]
	dec rax
	
	mov dl, BYTE PTR [rax]									# put last char in rsi
	
	cmp dl, 10
	je ._write
	jne ._notWrite
	
	._write:
		
		write [SocketFd], DataBuffer, [LastReadSize] 	# write whole buffer to server
		call WriteErrorCheck

		#for DEBUG
		write 1, StrColorFBlue, 5
		write 1, StrSentThis, 20 						
		write 1, DataBuffer, [LastReadSize]
		write 1, StrColorReset, 4

		xor rax, rax                                    #zero LastInputSize
		mov [LastReadSize], rax
		
		ret
		
	._notWrite:
		
		ret  											# do nothing


AutoPong:
# function that reads the server's response and if it detects a ping message sends an automatic pong response

	mov rax , [LastReadSize]
	cmp rax, 0
	jg .CheckPing

	.DoNothing:
		ret

	.CheckPing:

		mov rax,[DataBuffer]  # get the first 8 bytes from the data buffer
		
		cmp eax, 0x474E4950 # "PING" in hexadecimal
		je .RespondPing
		.DoNothing2:
			ret

		.RespondPing:

			call PrintData # so that the user knows a ping has been sent to them
		
			mov rax,[DataBuffer]  # get the first 8 bytes from the data buffer

			mov rdx, 0xFFFFFF0000000000
			and rax, rdx
			mov rdx, 0x00000020474e4f50 # "PONG " in hexadecimal
			or  rax, rdx

			mov [DataBuffer], rax

			call SendResponseToServer
			
			ret
