section .text
global _start

_start:
    pop rax
    cmp rax, 3
    jne error_param

    pop rax
    pop rdi
    call str_to_int
    mov r12, rax
    
    pop rdi
    call str_to_int
    
    add rax, r12
    
    mov rdi, rax
    call display_number
    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    mov rax, 60
    xor rdi, rdi
    syscall

error_param:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
    xor rcx, rcx
    cmp byte [rdi], '-'
    jne .next_char
    inc rdi
    mov rcx, 1

.next_char:
    movzx rdx, byte [rdi]
    test rdx, rdx
    jz .done
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rdi
    jmp .next_char

.done:
    test rcx, rcx
    jz .finish
    neg rax
.finish:
    ret

display_number:
    mov rax, rdi
    mov rsi, buffer
    mov byte [rsi], ' '
    inc rsi
    
    test rax, rax
    jns .convert
    neg rax
    mov byte [buffer], '-'

.convert:
    mov rcx, 10
    mov rdi, buffer_end
    mov byte [rdi], 0
    dec rdi

.convert_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .convert_loop

    lea rsi, [buffer]
    mov rdx, buffer_end
    sub rdx, rsi

    mov rax, 1
    mov rdi, 1
    syscall
    ret

section .data
    newline db 10
    error_msg db "Error: two parameters required", 10
    error_len equ $ - error_msg

section .bss
    buffer resb 20
    buffer_end equ buffer + 19