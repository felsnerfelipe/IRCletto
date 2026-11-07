
.intel_syntax noprefix

# this code was written by Felsner Felipe on 2026
# this is a simple IRC application written in pure x86
# it uses linux syscalls

#this file defines error check functions

# CODE | ERROR
# -1     generic error
# -2     not able to open socket
# -3     not able to connect to server
# -4     not able to write to server
# -5     no address or port was given to the program

.global CloseIfError
.global WriteErrorNoAddress
.global WriteErrorCheck
.global SocketErrorCheck
.global ConnectErrorCheck

.extern SocketFd

.section .text

# ERROR -1
CloseIfError:
#generic error

		#compare return to 0
		cmp rax, 0 

		#if less, close socket and program
		jl .closeSocket

		ret

		.closeSocket:
		
			#close socket
			close [SocketFd]	
							
			#close the app with error
			exit -1
			
# ERROR -2
SocketErrorCheck:

		#compare return to 0
		cmp rax, 0 

		#if less, close socket and program
		jl .ErrorFound

		ret

		.ErrorFound:
		
			#close socket
			close [SocketFd]	
						
			#close the app with error
			exit -2

		
# ERROR -3
ConnectErrorCheck:

		#compare return to 0
		cmp rax, 0 

		#if less, close socket and program
		jl .NotConnected

		ret

		.NotConnected:
		
			#close socket
			close [SocketFd]	
						
			#close the app with error
			exit -3

# ERROR -4
WriteErrorCheck:

		#compare return to 0
		cmp rax, 0 

		#if less, close socket and program
		jl .couldNotWrite

		ret

		.couldNotWrite:
		
			#close socket
			close [SocketFd]	
						
			#close the app with error
			exit -4

# ERROR -5
WriteErrorNoAddress:
    
    #close the app with error code
    exit -5


