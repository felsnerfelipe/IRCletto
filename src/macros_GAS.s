.intel_syntax noprefix

# a list of macros used in my assembly projects


# SYSCALLS

#read syscall
.macro read arg1, arg2, arg3
	mov rax, 0  # read syscall
	mov rdi, \arg1 # fd
	lea rsi, [rip +\arg2] # char*
	mov rdx, \arg3 # lenght
	syscall
.endm

#write syscall
.macro write arg1, arg2, arg3
	mov rax, 1  # write syscall
	mov rdi, \arg1 # fd
	lea rsi, [rip + \arg2] # char*
	mov rdx, \arg3 # lenght
	syscall
.endm

.macro lseek arg1, arg2, arg3
	mov rax, 8  # lseek syscall
	mov rdi, \arg1 # fd
	mov rsi, \arg2 # offset
	mov rdx, \arg3 # whence
	syscall
.endm

#close syscall
.macro close arg1
	mov rax, 3  # write syscall
	mov rdi, \arg1 # fd
	syscall
.endm

#open syscall
.macro open arg1, arg2, arg3
	mov rax, 2  # read syscall
	lea rdi, [rip + \arg1] # char*
	mov rsi, \arg2 # flag
	mov rdx, \arg3 # mode
	syscall
.endm

# exit syscall
.macro exit arg1
	mov rax, 60  # exit syscall
	mov rdi, \arg1  # error code
	syscall
.endm

# exit syscall
.macro nanosleep arg1, arg2
	mov rax, 35  # nanosleep syscall
	mov rdi, \arg1  # const struct timespec *duration
	mov rsi, \arg2  # struct timespec *_Nullable rem
	syscall
.endm

#poll syscall
.macro poll arg1, arg2, arg3
	mov rax, 7  # nanosleep syscall
	mov rdi, \arg1  # fds
	mov rsi, \arg2  # nfds
	mov rdx, \arg3  # timeout
	syscall
.endm

#fcntl syscall
.macro fcntl arg1, arg2, arg3
	mov rax, 72  # fcntl syscall
	mov rdi, \arg1  # fd
	mov rsi, \arg2  # unsigned int cmd
	mov rdx, \arg3  # .../args/...
	syscall
.endm

#ioctl syscall
.macro ioctl arg1, arg2, arg3
	mov rax, 16  # ioctl syscall
	mov rdi, \arg1  # fd
	mov rsi, \arg2  # unsigned int cmd
    lea rdx, [rip +\arg3]  # arg
	syscall
.endm


# GENERAL USE

#socket syscall
.macro socket arg1, arg2, arg3
	mov rax, 41  # socket syscall
	mov rdi, \arg1 # domain
	mov rsi, \arg2 # type
	mov rdx, \arg3 # protocol
	syscall
.endm

#connect syscall
.macro connect arg1, arg2, arg3
	mov rax, 42 # connect syscall
	mov rdi, \arg1 # Int sockFd
	lea rsi, [rip+\arg2] # const struct sockaddr *addr
	mov rdx, \arg3 # socklen_t addrlen
	syscall
.endm

#recv syscall
.macro recv arg1, arg2, arg3, arg4
	mov rax, 45    # recv syscall
	mov rdi, \arg1 # Int sockFd
	lea rsi, [rip +\arg2] # void buf[.len]
	mov rdx, \arg3 # size_t len
   	mov r10, \arg4 # int flags		        	                
	syscall
.endm


# NETWORKING
