;  gcc -S -masm=intel test.c -o asm_file.s

global _start

_start:
    mov rax, 60
    mov rdi, 0
    syscall