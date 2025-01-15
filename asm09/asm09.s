section .text
global _start

_start:
    mov rax, [rsp]

    cmp rax, 2
    je standard_convert
    cmp rax, 3
    je binary_convert
    jmp error_param

standard_convert:

    mov rsi, [rsp + 16]
    mov rdi, rsi
    call str_to_int
    mov rdi, rax
    call dec_to_hex
    jmp exit_success

binary_convert:
    mov rsi, [rsp + 16]
    cmp byte [rsi], '-'
    jne error_param
    cmp byte [rsi + 1], 'b'
    jne error_param

    mov rsi, [rsp + 24]
    mov rdi, rsi
    call str_to_int
    mov rdi, rax
    call dec_to_bin
    jmp exit_success

str_to_int:
    xor rax, rax
.convert_loop:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .convert_loop
.done:
    ret

dec_to_hex:
    mov rax, rdi
    mov rsi, buffer
    add rsi, 19
    mov byte [rsi], 0

    dec rsi
    mov rcx, 16

.hex_loop:
    xor rdx, rdx
    div rcx
    cmp dl, 10
    jge .letter
    add dl, '0'
    jmp .store
.letter:
    sub dl, 10
    add dl, 'A'
.store:
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .hex_loop

    inc rsi

    mov rax, 1
    mov rdi, 1
    
    mov rdx, buffer
    add rdx, 20
    sub rdx, rsi
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

dec_to_bin:
    mov rax, rdi
    mov rsi, buffer
    add rsi, 19
    mov byte [rsi], 0

    dec rsi
    mov rcx, 2

.bin_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .bin_loop

    inc rsi

    mov rax, 1
    mov rdi, 1

    mov rdx, buffer
    add rdx, 20
    sub rdx, rsi
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

error_param:
    mov rax, 60
    mov rdi, 1
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
    newline db 10

section .bss
    buffer resb 20
