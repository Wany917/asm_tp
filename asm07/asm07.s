section .data
    msg_error db "Erreur: veuillez entrer un nombre entier positif.", 0
    buffer db "Veuillez entrer un nombre: ", 0
    msg_zero db "0", 0

section .bss
    num resb 5
    output resb 20

section .text
    global _start

_start:
    ; Lire les paramètres de la ligne de commande
    pop rax             ; Nombre de paramètres (incluant le nom du programme)
    pop rsi             ; Sauter le nom du programme

    cmp rax, 2          ; Vérifier si deux paramètres sont fournis
    je _param_provided
    cmp rax, 1          ; Vérifier si un seul paramètre est fourni
    je _no_param_provided

    jmp _error

_param_provided:
    pop rsi             ; Obtenir le premier paramètre
    jmp _convert_param

_no_param_provided:
    ; Afficher le message pour entrer un nombre
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, buffer
    mov rdx, 27
    syscall

    ; Lire l'entrée de l'utilisateur
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, num
    mov rdx, 5
    syscall

    ; Vérifier si aucune entrée n'a été fournie
    cmp rax, 0
    je _error

    ; Supprimer le saut de ligne si présent
    dec rax
    cmp byte [rsi+rax], 10
    jne _check_empty_input
    mov byte [rsi+rax], 0

_check_empty_input:
    cmp byte [rsi], 0
    je _error

    mov rsi, num

_convert_param:
    ; Conversion de la chaîne en entier
    xor rax, rax
    xor rcx, rcx
    xor rdx, rdx
    mov r9, 10          ; Base 10

_AtoI:
    movzx rbx, byte [rsi + rcx]
    cmp rbx, 0          ; Fin de chaîne
    je _done_conversion
    sub rbx, '0'
    cmp rbx, 0
    jb _error
    cmp rbx, 9
    ja _error

    imul rax, r9
    add rax, rbx
    inc rcx
    jmp _AtoI

_done_conversion:
    cmp rax, 0
    je _print_zero

    ; Calcul de la somme de 1 à N-1
    mov r11, rax
    xor rax, rax
    xor rcx, rcx

_calculate_sum:
    inc rcx
    cmp rcx, r11
    jge _done_sum
    add rax, rcx
    jmp _calculate_sum

_done_sum:
    ; Conversion du résultat en chaîne
    lea rsi, [output + 20]
    mov byte [rsi], 0
    mov rbx, 10

_convert_to_string:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz _convert_to_string

_print_result:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    lea rdx, [output + 20]
    sub rdx, rsi
    mov rsi, rsi
    syscall

    ; Terminer le programme avec un code de sortie 0 (succès)
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

_print_zero:
    ; Afficher zéro
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg_zero
    mov rdx, 1
    syscall

    mov rax, 60         ; sys_exit
    syscall

_error:
    ; Sortie en cas d'erreur
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg_error
    mov rdx, 48
    syscall

    ; Terminer le programme avec un code de sortie 1 (échec)
    mov rax, 60         ; sys_exit
    mov rdi, 1
    syscall
