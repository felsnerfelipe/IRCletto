
.intel_syntax noprefix

# this code was written by Felsner Felipe on 2026
# this is a simple IRC application written in pure x86
# it uses linux syscalls

# this file defines functions that interpret inline arguments

.global ReadArgs
.global PrintHelpInfo
.global IpToAdress
.global StrToNumber

.extern temp 
.extern StrHelpInfo

ReadArgs:
# function responsible for read and interpreting the argument list

	# put 0 into rdi
	# rdi is the current index of the argument
	xor rdi,rdi 

	#the pointer to the function calling (DO NOT CHANGE)
	pop r10 
	mov [temp], r10

	# get argc
	pop rax
	mov [argc], rax

	pop rax # useless (name of the file)

	#argv[1]
	pop rdx
	mov ax, WORD PTR [rdx]

	#check if it is -h
	cmp ax, 0x682D
	jnz .NoHelp

		jmp PrintHelpInfo
		
	.NoHelp:

	# ifnot then it probably is the address	
	#cmp ax, 0x612D 
	cmp ax, 0x612D 
	je .AddressFound

		jmp WriteErrorNoAddress

	.AddressFound:

	#get address
	pop rax
	mov [argv], rax

	call IpToAdress # convert addres to not string
	
	#the pointer to the function calling (DO NOT CHANGE)
	mov r10, [temp]
	push r10

	ret


PrintHelpInfo:

	# print info
	write 1, StrHelpInfo, 57 
	
	# exit gracefully
	exit 0


IpToAdress:
#function that takes argv string and puts it in sockaddr struct ip 
# converts a ip from string format to number format

	# notice to any people that need to touch this function!
	# DONT! it is cursed, it is probably horrably unoptimised
	# and i WONT touch it again!
	
	mov rdx, [argv]        #pointer to argv
	lea rsi, [rip + ipnumber]      #pointer to number string
	add rsi, 2
	mov rbx, 0           #number of digit of a certain number
	mov rdi, 0           #index of char

	# FIRST BYTE 
	
	mov rcx,4
	.FirstDotLoop:
		
		mov rdx, [argv]
		add rdx, rdi
		inc rdi

		mov al, BYTE PTR [rdx]
		cmp al, 0x2E       #check if found dot
		je .EndFirstDotLoop

			inc rbx

	loop .FirstDotLoop
	.EndFirstDotLoop:
	mov rcx, rbx
	.CopyToNumber1:

		dec rdx
		mov al , BYTE PTR [rdx]
		mov [rsi], al
		dec rsi
		
	loop .CopyToNumber1
	
	call StrToNumber # convert to integer
	mov BYTE PTR [sockaddr + 4],  al # store in memory


	# SECOND BYTE

	add rdx, rbx  # get rdx back to original value
	mov rbx, 0
	
	lea rsi, [rip + ipnumber]    #pointer to number string
	add rsi, 2

	# gey ipnumber back to 000
	mov al, 0x30 
	mov BYTE PTR [ipnumber], al
	mov BYTE PTR [ipnumber+1], al
	mov BYTE PTR [ipnumber+2], al

	mov rcx,4
	.SecondDotLoop:
		
		mov rdx, [argv]
		add rdx, rdi
		inc rdi

		mov al, BYTE PTR [rdx]
		cmp al, 0x2E          #check if found dot
		je .EndSecondDotLoop

			inc rbx

	loop .SecondDotLoop
	.EndSecondDotLoop:
	mov rcx, rbx
	.CopyToNumber2:

		dec rdx
		mov al , BYTE PTR [rdx]
		mov [rsi], al
		dec rsi
		
	loop .CopyToNumber2

	call StrToNumber # convert to integer
	mov BYTE PTR [sockaddr + 5],  al # store in memory

	# THIRD BYTE

	add rdx, rbx  # get rdx back to original value
	mov rbx, 0
	
	lea rsi, [rip + ipnumber]    #pointer to number string
	add rsi, 2

	# gey ipnumber back to 000
	mov al, 0x30 
	mov BYTE PTR [ipnumber], al
	mov BYTE PTR [ipnumber+1], al
	mov BYTE PTR [ipnumber+2], al

	mov rcx,4
	.ThirdDotLoop:
		
		mov rdx, [argv]
		add rdx, rdi
		inc rdi

		mov al, BYTE PTR [rdx]
		cmp al, 0x2E          #check if found dot
		je .EndThirdDotLoop

			inc rbx

	loop .ThirdDotLoop
	.EndThirdDotLoop:
	mov rcx, rbx
	.CopyToNumber3:

		dec rdx
		mov al , BYTE PTR [rdx]
		mov [rsi], al
		dec rsi
		
	loop .CopyToNumber3
	
	call StrToNumber # convert to integer
	mov BYTE PTR [sockaddr + 6],  al # store in memory

	# FORTH BYTE

	add rdx, rbx  # get rdx back to original value
	mov rbx, 0
	
	lea rsi, [rip + ipnumber]    #pointer to number string
	add rsi, 2

	mov al, 0x30 
	mov BYTE PTR [ipnumber], al
	mov BYTE PTR [ipnumber+1], al
	mov BYTE PTR [ipnumber+2], al

	mov rcx,4
	.ForthDotLoop:
		
		mov rdx, [argv]
		add rdx, rdi
		inc rdi

		mov al, BYTE PTR [rdx]
		cmp al, 0          #check if found end of string
		je .EndForthDotLoop

			inc rbx

	loop .ForthDotLoop
	.EndForthDotLoop:
	mov rcx, rbx
	.CopyToNumber4:

		dec rdx
		mov al , BYTE PTR [rdx]
		mov [rsi], al
		dec rsi
		
	loop .CopyToNumber4

	add rdx, rbx  # get rdx back to original value
	
	lea rsi, [rip + ipnumber]    #pointer to number string
	add rsi, 2
	inc rdi
	
	call StrToNumber # convert to integer
	mov BYTE PTR [sockaddr + 7],  al # store in memory

	ret
	

StrToNumber:
# converts ipnumber to integer and puts value into rax

	lea rsi, [rip + ipnumber]
	xor rax,rax

	#hundred's place
	movzx rdx, BYTE PTR [rsi]
	sub rdx, 0x30 
	imul rdx, 100
	mov rax, rdx
	inc rsi

	#ten's place
	movzx rdx, BYTE PTR [rsi]
	sub rdx, 0x30 
	imul rdx, 10
	add rax, rdx
	inc rsi

	#unit's place
	movzx rdx, BYTE PTR [rsi]
	sub rdx, 0x30 
	add rax, rdx

	#result is in rax ;)
	ret
	
