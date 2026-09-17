
; this code was written by Felsner Felipe on 2026
; this is a simple IRC application written in pure x86
; it uses linux syscalls

; this file is part of the code, it defines functions that mess with stdin or stdout

GetSizeTerminal:
; function that manually stores the size of the terminal
; this function should be ran periodicly to account to dimention changes of modern terminal
; emulators

	; THIS FUNCTION IS THE BAIN OF MY EXISTENCE
	; IT DOES NOT WANT TO FOLLOW GOD'S RULE
	; MAY YOU BE WARNED IF YOU SHALL MODIFY 
	; THIS CODE! NOTHING AFTER THIS LINE IS
	; SACRED...
	;----------------------------------------------------------------------------------

	;these 3 lines were written by an LLM i do not fully understand how they work
	ioctl 0, 0x5401, OriginalTerminalSettings
	ioctl 0, 0x5401, TerminalSettings
	and dword [TerminalSettings + 12], ~(2 | 8)
	ioctl 0, 0x5402, TerminalSettings

	write 1, StrGoDown999Cursor,  6 ; move to bottom right corner
	write 1, StrGoRight999Cursor, 6

	write 0, StrPosReport, 4 ; ask for position

	read 0, PosReportBuffer,10 ; read report

	xor rdx,rdx
	mov rdx, PosReportBuffer ; skip "ESC["
	add rdx, 2 

	mov rdi, 0 ; i variable
	.LoopSemiColon: ;logical while loop starts at 0 stops when buffer[rdi+i] = ';'
		cmp byte [ rdx + rdi ], ';'  ; if buffer[rdi+i] = ';'      ;X[DDD;DDDR
		jne .Continue1

			; FOUND ';'
		
			add rdx,rdi	; set index to ';'+1s place
			inc rdx
			xor rdi,rdi	; reset i
			jmp .EndLoopSemiColon
			
		.Continue1:

		;put number char in FirstNumber
		mov rcx, FirstNumber 
		add rcx, rdi

		mov al, [ rdx + rdi ]
		
		mov [rcx], al

		;next i value
		inc rdi
		jmp .LoopSemiColon

	.EndLoopSemiColon:
	
	.LoopR: ;logical while loop starts at 0 stops when buffer[rdi+i] = 'R'
			cmp byte [ rdx + rdi ], 'R'  ; if buffer[rdi+i] = 'R'
			je .FoundR
			jne .Continue2
			.FoundR:
	
				add rdx,rdi	; set index to 'R's place
				xor rdi,rdi	; reset i
				jmp .EndLoopR
				
			.Continue2:

	
			;put number char in SecondNumber
			mov rcx, SecondNumber
			add rcx, rdi
	
			mov al, [ rdx + rdi ]
			
			mov [rcx], al
	
			;next i value
			inc rdi
			jmp .LoopR
	
	.EndLoopR:

	;these 2 lines were written by an LLM i do not fully understand how they work
	
	ioctl 0, 0x5402, OriginalTerminalSettings
	
	ret
	

ClearTerminal:
;function that prints ainsi escape to clean terminal

	write 1, StrClearScreen, 4


ReadUserInput:
; function that reads input from the user

	;test if there is info available in stdin
	ioctl 0 , 0x541B , BytesStdin   ;this return number of character aavailable in stdin btw
	mov rax, [BytesStdin]
	cmp rax, 0
	jle .Return
	jmp .Read

	; info unavailable
	.Return: 						
		ret

	; info available
	.Read: 			

		
		read 0, UserBuffer, 1024 
		mov [LastInputSize], rax    
		; update number of characters read
		xor rax,rax
		mov [BytesStdin], rax
		ret 
	

PrintData:
; function to print server data to user

	write 1,StrGoUp1Cursor,4
	write 1,StrGoRight999Cursor,6
	write 1, StrNewLine,1
	;write 1,StrClearLine,4

	write 1, StrColorFYellow, 5 ; color
	write 1, DataBuffer, [LastReadSize]  ;print data to console
	write 1, StrColorReset,5
	call CloseIfError

	;write 1, StrGoDown999Cursor, 6
	;write 1,StrClearLine,4	

	ret


