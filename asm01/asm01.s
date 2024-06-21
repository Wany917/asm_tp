
global _start

section .data
    number db "1337", 0xa
    number_len equ $ - number

section .text
    _start:
        mov rax, 1
        mov rdi, 1
        mov rsi, number
        mov rdx, number_len
        syscall

        mov rax, 60
        xor rdi, rdi
        syscall

; mov rax, 1 -> syscall write
; mov rdi, 1 -> file descriptor 1 (stdout)
; mov rsi, number -> the address of the number
; mov rdx, number_len -> the length of the number
; syscall -> call the syscall write
; mov rax, 60 -> syscall exit
; xor rdi, rdi -> set rdi to 0
; syscall -> call the syscall exit

; nasm -f elf64 -o asm01.o asm01.s