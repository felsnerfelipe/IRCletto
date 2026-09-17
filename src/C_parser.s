
section .data

	CurrentChannel db "                         " ; 25 bytes max

	StrPRIVMSG db "PRIVMSG "; 8 bytes

section .text

ParseInput:
;main function that uses all the functions defined here to parse and treat user input

	;see if user typed anything
	call ReadUserInput
	call WriteToServer

CheckIfCommand:
;function that checks if User inputed string starts with an "/" and return 0 
;if true and 1 if false thru rax register

	mov al, byte [UserBuffer]
	cmp al, "/"
	je .True

		mov rax, 1
		ret
		
	.True:

		xor rax,rax
		ret

FormatPRIVMSG:
; puts the string inputed by user in usable PRIVMSG <channel> :<message> format

	; put original string 33 bytes away
	; len(StrPRIVMSG)+len(CurrentChannel)+':'=34
	mov rdi, UserBuffer
	add rdi, [LastInputSize]
	dec rdi

	mov rcx, [LastInputSize]
	dec rcx
	.move:

		mov rax, [rdi]
		mov [rdi+34], rax ; copy to another location

		dec rdi
		
		xor rax,rax
		mov [rdi], rax	; zero the original
		
		loop .move

	; put StrPRIVMSG at the start

	mov rcx, 8
	.copy:

		dec rcx
		
		mov rdi, UserBuffer	; pointer to UserBuffer
		mov rdx, StrPRIVMSG ; pointer to StrPRIVMSG
		
		add rdi, rcx ; UserBuffer+i
		add rdx, rcx ; StrPRIVMSG+i
		
		mov rax, [rdx] ; put value of StrPRIVMSG+i into rax
		mov [rdi], rax ; put value of rax into UserBuffer+i
		
		inc rcx

		loop .copy	

	mov rcx, 25
		.paste:
	
			dec rcx
			
			mov rdi, UserBuffer	; pointer to UserBuffer
			add rdi,8 
			mov rdx, CurrentChannel ; pointer to CurrentChannel
			
			add rdi, rcx ; UserBuffer+i
			add rdx, rcx ; StrPRIVMSG+i
			
			mov rax, [rdx] ; put value of CurrentChannel+i into rax
			mov [rdi], rax ; put value of rax into UserBuffer+i
			
			inc rcx
	
			loop .paste

	mov rdi,UserBuffer
	add rdi, 33
	mov rax, ':'
	mov [rdi], rax

	call WriteToServer

	;and presto!
	ret 		
