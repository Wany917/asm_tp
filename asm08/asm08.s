section .text
global _start

_start:
    pop rax                 
    cmp rax, 2
    jne error_param
    
    pop rax             
    pop rdi             
    call str_to_int
    
    mov rdi, rax          ; N
    dec rdi               ; N-1 (on veut les nombres inférieurs)
    call calculate_sum
    
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
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
.next:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rdi
    jmp .next
.done:
    ret

calculate_sum:
    cmp rdi, 0            ; si N ≤ 0
    jle .zero
    mov rcx, rdi          ; compteur = N
    mov rax, rdi          ; premier nombre
.loop:
    dec rcx               ; prochain nombre
    jz .done             ; si on arrive à 0
    add rax, rcx          ; ajouter à la somme
    jmp .loop
.zero:
    xor rax, rax         ; retourner 0
.done:
    ret

display_number:
    mov rax, rdi
    mov rsi, buffer
    add rsi, 19
    mov byte [rsi], 0
    
    test rax, rax
    jnz .convert
    mov byte [buffer], '0'
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 1
    syscall
    ret
    
.convert:
    dec rsi
    mov rcx, 10
    
.next_digit:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz .next_digit
    
    mov rax, 1
    mov rdi, 1
    mov rdx, buffer
    add rdx, 20
    sub rdx, rsi
    dec rdx
    syscall
    ret

section .data
    newline db 10

section .bss
    buffer resb 20