section .text
global _start

_start:
    pop rcx
    cmp rcx, 4
    jne error_param
    
    pop rcx                 ; nom programme
    pop rdi                 ; premier nombre
    call str_to_int
    mov r12, rax           ; n1
    
    pop rdi                 ; deuxième nombre
    call str_to_int
    mov r13, rax           ; n2
    
    pop rdi                 ; troisième nombre
    call str_to_int
    mov r14, rax           ; n3
    
    ; Trouver le max
    mov rax, r12
    cmp rax, r13
    jge .check_n3
    mov rax, r13
.check_n3:
    cmp rax, r14
    jge .print_result
    mov rax, r14
    
.print_result:
    mov rdi, rax
    call display_number

    mov rax, 1              ; write
    mov rdi, 1              ; stdout
    mov rsi, newline        ; \n
    mov rdx, 1              ; length
    syscall
    
    mov rax, 60             ; exit
    xor rdi, rdi            ; code 0
    syscall

error_param:
    mov rax, 60
    mov rdi, 1
    syscall

; Convertit string en nombre
str_to_int:
    xor rax, rax
    xor rcx, rcx            ; flag négatif
    
    cmp byte [rdi], '-'     ; check signe
    jne .convert
    inc rdi
    mov rcx, 1
    
.convert:
    movzx rdx, byte [rdi]
    test rdx, rdx
    jz .done
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rdi
    jmp .convert
    
.done:
    test rcx, rcx           ; si négatif
    jz .end
    neg rax                 ; rendre négatif
.end:
    ret

; Convertit et affiche un nombre
display_number:
    mov rax, rdi            ; nombre à afficher
    mov r8, 10              ; base 10
    mov rdi, buffer
    add rdi, 20             ; fin du buffer
    mov byte [rdi], 0       ; null terminator
    
    ; Check si négatif
    test rax, rax
    jns .convert
    neg rax
    push rax                ; sauver le nombre
    mov al, '-'
    mov [output], al        ; mettre le - au début
    pop rax
    mov byte [output+1], 0  ; terminator après le -
    inc r9                  ; incrémenter longueur
    
.convert:
    dec rdi                 ; reculer dans le buffer
    xor rdx, rdx
    div r8                  ; diviser par 10
    add dl, '0'             ; convertir en ASCII
    mov [rdi], dl           ; stocker le caractère
    test rax, rax
    jnz .convert
    
    mov rax, 1              ; write
    mov rsi, rdi            ; pointer sur le début du nombre
    mov rdx, buffer
    add rdx, 21             ; fin du buffer + 1
    sub rdx, rdi            ; calculer la longueur
    push rsi                ; sauver le pointeur
    push rdx                ; sauver la longueur
    syscall                 ; afficher
    
    ret

section .data
    newline db 10

section .bss
    buffer resb 21
    output resb 21