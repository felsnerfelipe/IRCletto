<img src="./Images/Logo.png" alt="BareIRC" width="40%" height="5%">

bareIRC is an open-source IRC client aimed at being an extremely bare-bones IRC client.
It is 100% coded in x86_64 assembly, so it is compact and lightweight, with
no library or framework behind it. It is really simple and concise while
allowing you to see what's happening under the hood.

## Features

>[!IMPORTANT]
>bareIRC is in early development, and many of the features described here are not yet available. The features have two tags: WIP (Work In Progress), NIY (Not Implemented Yet).

bbIRC does not aim to be a feature-rich IRC client such as [weechat](https://weechat.org/)
 or [senpai](https://sr.ht/~taiite/senpai/)
; rather, it was mainly created as a tool to understand and debug IRC servers. By using it, you are directly talking to the server without any kind of intermediate step.

- easy connection (WIP)
- debug mode (NIY)
- handling of commands via macros like /quit, /list (WIP)
- automated commands (NIY)

## installation (WIP)

for the moment there is no real way of "installing" bbIRC, but you can compile directly from source!
```
git clone https://github.com/Felipeshaolin/bbIRC.git
cd bbIRC  
nasm -f elf64 irc.s -o bin/bbIRC.o
ld bin/bbIRC.o -o bin/bbIRC
```
the executable should now be in the bbIRC/bin/ folder.

## why?

This project was created as a means to remove the scary nature of IRC and shed light on it for people trying to use it for the first time. Also, as the development went on, I discovered just how useful having a program that could send handmade commands to the server really is.

 ## future

My main goal for this project in the future is to port it to as many platforms as I can. For now, bbIRC works only on the Linux x86_64 operating system; a port to other architectures is inevitable, as well as ports to other operating systems. Furthermore, as time goes on, more and more quality-of-life improvements will be made.
