section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 20
    syscall

    test rax, rax
    jle error_input

    mov rdi, buffer
    call str_to_int
    
    cmp rax, 1
    jle not_prime
    
    mov rdi, rax
    call is_prime
    test rax, rax
    jnz not_prime

exit_prime:
    mov rax, 60
    xor rdi, rdi
    syscall

not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

error_input:
    mov rax, 1
    mov rdi, 2
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    mov rax, 60
    mov rdi, 2
    syscall

str_to_int:
    xor rax, rax
    xor rcx, rcx

.next_char:
    movzx rdx, byte [rdi]
    cmp rdx, 10
    je .done
    cmp rdx, '0'
    jl error_input
    cmp rdx, '9'
    jg error_input
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rdi
    jmp .next_char

.done:
    ret

is_prime:
    cmp rdi, 2
    je .is_prime
    
    mov rcx, 2
    mov rax, rdi
    
.check_loop:
    xor rdx, rdx
    div rcx
    test rdx, rdx
    jz .not_prime
    
    mov rax, rdi
    inc rcx
    cmp rcx, rdi
    jl .check_loop
    
.is_prime:
    xor rax, rax
    ret
    
.not_prime:
    mov rax, 1
    ret

section .data
    error_msg db "Error: invalid input", 10
    error_len equ $ - error_msg

section .bss
    buffer resb 20