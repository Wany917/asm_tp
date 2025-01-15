global _start

section .data

section .bss
output resb 32

section .text

_start:
    pop rax
    cmp rax, 4
    je args_ok

    mov rax, 60
    mov rdi, 1
    syscall

args_ok:
    pop rsi
    pop rsi           
    call atoi
    mov r8, rax
    pop rsi            
    call atoi
    mov r9, rax
    pop rsi          
    call atoi
    mov r10, rax

    mov rax, r8
    cmp r9, rax
    cmovg rax, r9
    cmp r10, rax
    cmovg rax, r10

    mov rdi, rax
    call itoa
    mov rax, 1
    mov rdi, 1
    lea rdx, [output + 31]
    sub rdx, rsi
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

atoi:
    xor rax, rax
    xor rcx, rcx       
    mov dl, [rsi]
    cmp dl, '-'
    jne .loop
    inc rsi
    mov rcx, 1

.loop:
    mov dl, [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .loop

.done:
    test rcx, rcx
    jz .ret
    neg rax
.ret:
    ret

itoa:
    mov rax, rdi
    mov rsi, output + 31
    test rax, rax
    jge .conv_loop
    neg rax
    mov rcx, 1          

.conv_loop:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .conv_loop

    test rcx, rcx
    jz .done
    dec rsi
    mov byte [rsi], '-'

.done:
    ret