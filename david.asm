%define SYS_WRITE 1
%define SYS_CLOSE 3
%define SYS_EXIT 60
%define SYS_SOCKET 41
%define SYS_BIND 49
%define SYS_LISTEN 50

%define SOCK_STREAM 1
%define AF_INET 2

SECTION .data
msg 	db 	'Hello World!', 0x0A
socketaddr:
    dw AF_INET
    dw 0x371B
    dd 0x0100007F
    dq 0

SECTION .bss
    sfd resq 1

SECTION .text
global _start

_start:
    mov     r8,     0
    mov     r9,     10
    mov     r10,    0
lp:
	mov	    rax,	SYS_WRITE
	mov	    rdi,	1
	mov	    rsi,	msg
	mov	    rdx,	13
	syscall
    add     r10,    r8
    inc     r8
    cmp     r8,     r9
    jl      lp

_start2:
    ; create socket
    mov     rax,    SYS_SOCKET
    mov     rdi,    AF_INET
	mov	    rsi,	SOCK_STREAM
    xor     rdx,    rdx
    syscall
    mov     [sfd],  rax

    ; bind socket
    mov     rax,    SYS_BIND
    mov     rdi,    [rel sfd]
    lea     rsi,    [rel socketaddr]
    mov     rdx,    16
    syscall

    ; listen socket
    mov     rax,    SYS_LISTEN
    mov     rdi,    [rel sfd]
    mov     rsi,    50
    syscall

_lp2:
    jmp     _lp2

    ; close socket
    mov     rax,    SYS_CLOSE
    mov     rsi,    sfd

    ; exit
	mov 	rax, 	SYS_EXIT
	mov 	rdi, 	0
	syscall

