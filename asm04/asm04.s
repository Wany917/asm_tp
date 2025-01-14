global _start

section .data

section .bss
    input resb 11            ; Réserve un espace pour 11 caractères de l'utilisateur

section .text
_start:
    ; Lit 11 caractères depuis l'entrée standard et les stocke dans 'input'
    mov eax, 0
    mov edi, 0
    mov rsi, input
    mov edx, 11
    syscall

    ; Positionne le pointeur sur le dernier caractère lu
    mov rdi, input
    add rdi, 10

_dernier:
    ; Vérifie si le caractère est un chiffre (entre '0' et '9')
    cmp byte [rdi], 0x30
    jb _verifier
    cmp byte [rdi], 0x39
    ja _verifier
    ; Si c'est un chiffre, passe au calcul du résultat
    jmp _resultat            

_verifier:
    ; Compare avec le début du buffer
    cmp rdi, input
    jb _error
    ; Si ce n'est pas un chiffre, recule d'un caractère et recommence
    dec rdi                       
    jmp _dernier

_error:
    ; Retourne le code d'erreur 2 pour une entrée invalide
    mov rax, 60
    mov rdi, 2
    syscall

_resultat:
    ; Convertit le caractère ASCII en chiffre
    movzx eax, byte [rdi]         
    sub eax, '0'                  

    ; Vérifie si le chiffre est pair ou impair
    and eax, 1                    
    jnz _impair                      

    ; Si pair, termine le programme avec le code de sortie 0
    mov rax, 60
    mov rdi, 0
    syscall

_impair:
    ; Si impair, termine le programme avec le code de sortie 1
    mov rax, 60
    mov rdi, 1
    syscall
