global _start

section .data
    number db '1337', 0x0A  ; Chaîne de caractères "1337" suivie d'un saut de ligne

section .text

_start:
    ; Vérifie s'il n'y a pas d'arguments passés
    mov rdi, [rsp]
    cmp rdi, 1
    je no_args

    ; Récupère le premier argument passé au programme
    mov rsi, [rsp + 16]

    ; Compare le premier caractère de l'argument à "4"
    mov al, [rsi]
    cmp al, 0x34
    jne not_42

    ; Compare le deuxième caractère de l'argument à "2"
    mov al, [rsi + 1]
    cmp al, 0x32
    jne not_42

    ; Vérifie si le troisième caractère est nul (fin de chaîne)
    mov al, [rsi + 2]
    cmp al, 0x00
    jne not_42

    ; Si l'argument est "42", affiche "1337"
    mov rax, 1
    mov rdi, 1
    mov rsi, number
    mov rdx, 5
    syscall

    ; Termine le programme avec le code de sortie 0
    mov rax, 60
    mov rdi, 0
    syscall

not_42:
    ; Si l'argument n'est pas "42", termine avec le code de sortie 1
    mov rax, 60
    mov rdi, 1
    syscall

no_args:
    ; Si aucun argument n'est passé, termine avec le code de sortie 1
    mov rax, 60
    mov rdi, 1
    syscall
