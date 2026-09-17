

; a list of macros used in my assembly projects


; SYSCALLS

;read syscall
%macro read 3
	mov rax, 0  ; read syscall
	mov rdi, %1 ; fd
	mov rsi, %2 ; char*
	mov rdx, %3 ; lenght
	syscall
%endmacro

;write syscall
%macro write 3
	mov rax, 1  ; write syscall
	mov rdi, %1 ; fd
	mov rsi, %2 ; char*
	mov rdx, %3 ; lenght
	syscall
%endmacro

%macro lseek 3
	mov rax, 8  ; lseek syscall
	mov rdi, %1 ; fd
	mov rsi, %2 ; offset
	mov rdx, %3 ; whence
	syscall
%endmacro

;close syscall
%macro close 1
	mov rax, 3  ; write syscall
	mov rdi, %1 ; fd
	syscall
%endmacro

;open syscall
%macro open 3
	mov rax, 2  ; read syscall
	mov rdi, %1 ; char*
	mov rsi, %2 ; flag
	mov rdx, %3 ; mode
	syscall
%endmacro

; exit syscall
%macro exit 1
	mov rax, 60  ; exit syscall
	mov rdi, %1  ; error code
	syscall
%endmacro

; exit syscall
%macro nanosleep 2
	mov rax, 35  ; nanosleep syscall
	mov rdi, %1  ; const struct timespec *duration
	mov rsi, %2  ; struct timespec *_Nullable rem
	syscall
%endmacro

;poll syscall
%macro poll 3
	mov rax, 7  ; nanosleep syscall
	mov rdi, %1  ; fds
	mov rsi, %2  ; nfds
	mov rdx, %3  ; timeout
	syscall
%endmacro

;fcntl syscall
%macro fcntl 3
	mov rax, 72  ; fcntl syscall
	mov rdi, %1  ; fd
	mov rsi, %2  ; unsigned int cmd
	mov rdx, %3  ; .../args/...
	syscall
%endmacro

;ioctl syscall
%macro ioctl 3
	mov rax, 16  ; ioctl syscall
	mov rdi, %1  ; fd
	mov rsi, %2  ; unsigned int cmd
	mov rdx, %3  ; arg
	syscall
%endmacro


; GENERAL USE

;socket syscall
%macro socket 3
	mov rax, 41  ; socket syscall
	mov rdi, %1 ; domain
	mov rsi, %2 ; type
	mov rdx, %3 ; protocol
	syscall
%endmacro

;connect syscall
%macro connect 3
	mov rax, 42 ; connect syscall
	mov rdi, %1 ; Int sockFd
	mov rsi, %2 ; const struct sockaddr *addr
	mov rdx, %3 ; socklen_t addrlen
	syscall
%endmacro

;recv syscall
%macro recv 4
	mov rax, 45 ; recv syscall
	mov rdi, %1 ; Int sockFd
	mov rsi, %2 ; void buf[.len]
	mov rdx, %3 ; size_t len
   	mov r10, %4 ; int flags		        	                
	syscall
%endmacro


; NETWORKING
