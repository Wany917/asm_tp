; this program must do display 1337 and return 0 if he receive 42 only else return 1 use the syscall
; i already know how to use the syscall but i don't know how to compare the input with 42
; i'm using nasm and i'm a beginner in assembly
; so i've already do something like this look : 
; global _start

; section .data
;     number db "1337", 0xa
;     number_len equ $ - number

; section .text
;     _start:
;         mov rax, 1
;         mov rdi, 1
;         mov rsi, number
;         mov rdx, number_len
;         syscall

;         mov rax, 60
;         xor rdi, rdi
;         syscall


; but i don't know how to compare the input with 42
; help me

global _start

section .bss
    input resb 32

section .text
    msg: db "1337", 0xa
    msg_len: equ $ - msg
    val: dw "42", 0xa

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 32
    syscall

    mov eax, [input]
    cmp eax, [val]
    je display

    mov rax, 60
    mov rdi, 1
    syscall

display:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

; nasm -f elf64 -o asm02.o asm02.s
; ld -o asm02 asm02.o
; ./asm02