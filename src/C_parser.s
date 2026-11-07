.intel_syntax noprefix

# this code was written by Felsner Felipe on 2026
# this is a simple IRC application written in pure x86
# it uses linux syscalls

#this file defines functions responsable for parsing and interpreting user commands

.section .text

.global ParseInput
.global ParseInput
.global FormatPRIVMSG

.extern ReadUserInput
.extern CheckIfCommand
.extern LastInputSize
.extern LastReadSize
.extern UserBuffer
.extern WriteToServer 
.extern StrPRIVMSG

ParseInput:
#main function that uses all the functions defined here to parse and treat user input

	#see if user typed anything
	call ReadUserInput
	call CheckIfCommand
	#call WriteToServer

CheckIfCommand:
#function that checks if User inputed string starts with an "/" 

	xor rax, rax
	cmp rax, [LastInputSize]
	je .NoInput
		
		mov al, BYTE PTR [UserBuffer]
		cmp al, '/'
		je .True
		
			call FormatPRIVMSG
			ret
			
		.True:

			mov al,' '
			mov [UserBuffer], al

			call WriteToServer
			
			ret

	.NoInput:
		ret

FormatPRIVMSG:
# puts the string inputed by user in usable PRIVMSG <channel> :<message> format

	# put original string 33 bytes away
	# len(StrPRIVMSG)+len(CurrentChannel)+':'=34
	lea rdi, [rip+UserBuffer]
	add rdi, [LastInputSize]
	dec rdi					# rdi points to last char in UserBuffer

	mov rcx, [LastInputSize] 
	.move:

		mov al, BYTE PTR [rdi]
		mov [rdi+34], al # copy to another location
		
		xor rax,rax
		mov [rdi], al # zero the original
		
		dec rdi
		
		loop .move

	# put StrPRIVMSG at the start
	# len(StrPRIVMSG) = 8
	mov rcx, 8 # rcx - 1 = i
	.copy:

		dec rcx
		
		lea rdi, [rip+UserBuffer]	# pointer to UserBuffer
		lea rdx, [rip+StrPRIVMSG] # pointer to StrPRIVMSG
		
		add rdi, rcx # UserBuffer+i
		add rdx, rcx # StrPRIVMSG+i
		
		mov al, BYTE PTR [rdx] # put value of StrPRIVMSG+i into rax
		mov [rdi], al # put value of rax into UserBuffer+i
		
		inc rcx

		loop .copy	

	# len(CurrentChannel) = 25
	mov rcx, 25 # rcx -1 = i
		.paste:
	
			dec rcx
			
			lea rdi, [rip+UserBuffer]	# pointer to UserBuffer
			add rdi, 8 # because len(StrPRIVMSG) = 8
			lea edx, [rip+CurrentChannel] # pointer to CurrentChannel
			
			add rdi, rcx # UserBuffer+i
			add rdx, rcx # StrPRIVMSG+i
			
			mov al, BYTE PTR [rdx] # put value of CurrentChannel+i into rax
			mov [rdi], al # put value of rax into UserBuffer+i
			
			inc rcx
	
			loop .paste

	lea rdi,[rip+UserBuffer]
	add rdi, 33 # because len(StrPRIVMSG)+len(CurrentChannel) = 33
	mov al, ':'
	mov [rdi], al

	mov rax, [LastInputSize]
	add rax, 34
	mov [LastInputSize], rax

	call WriteToServer

	#and presto!
	ret 		
