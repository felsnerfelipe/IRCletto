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
.extern CurrentChannel

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

            #check if the JOIN command was typed 
            call HandleJoin 
            cmp rax,0
            jz .writeToServer 
            
            .writeToServer:
			    call WriteToServer

	.NoInput:
		ret

#functions to handle specific commands

HandleJoin:
# function that, if it detects the Join command, will change the current Channel
# returns 0 in rax if join was detected ifnot return 1 
    
    #get pointer to UserBuffer String
    lea esi, [rip + UserBuffer]  

    # part that copies and upper-cases the string onto edi
    xor edi, edi
    mov rcx, 4
    .loopUpperCase:
        inc esi
        shl edi, 8 
        mov al, BYTE PTR [esi]
        cmp al, 0x5B
        jg .decrement
        jmp .loopBack
    .decrement:
        sub al, 0x20
        mov dil, al 
    .loopBack:
        loop .loopUpperCase
    
    #check if edi has "JOIN" in it
    cmp edi, 0x4A4F494E
    mov rax, 1 # return status
    jne .return 

    #zero out CurrentChannel
    mov rcx,23 
    lea edi, [rip + CurrentChannel]
    .ZeroCurrentChannelLoop:
        mov [edi], BYTE PTR ' ' 
        inc edi
        loop .ZeroCurrentChannelLoop

    mov rcx, [LastInputSize]
    dec rcx # to avoid '\n'
    sub rcx, 6 # "/join " -> 6 chars
    add esi, 2 # put pointer on start of string
    lea edi, [rip + CurrentChannel]
    .changeChannel:
        #copies the channel name into currentChannel  
        mov bl, [esi]
        mov [edi], bl 
        inc edi  
        inc esi
        loop .changeChannel

    #return status
    mov rax, 0

    .return:
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
