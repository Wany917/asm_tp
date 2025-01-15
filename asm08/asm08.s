; asm08.s
; ---------------------------------------
; Calcule la somme des entiers 1..(N-1).
; Usage:
;   ./asm08 5  => 10
;   ./asm08 10 => 45
;   ./asm08 1  => 0
; ---------------------------------------

section .text
global _start

; -------------------------------
; Point d'entrée
; -------------------------------
_start:
    ; Récupère argc dans rax
    mov rax, [rsp]        ; rax = argc
    cmp rax, 2            ; 1 argument utilisateur => argc=2
    jne error_param

    ; Récupère argv[1] = [rsp + 16]
    mov rsi, [rsp + 16]

    ; Convertit argv[1] en entier => rax
    mov rdi, rsi
    call str_to_int       
    ; On place N dans rdi
    mov rdi, rax

    ; Calcule sum(1..(N-1)) => rax
    call calculate_sum

    ; Affiche le résultat (stocké dans rax)
    mov rdi, rax
    call display_number

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

; -------------------------------
; error_param:
;   sort du programme avec code 1
; -------------------------------
error_param:
    mov rax, 60
    mov rdi, 1
    syscall

; -------------------------------
; str_to_int:
;   Convertit la chaîne pointée par rdi
;   en nombre entier (base 10).
;   Résultat dans rax.
; -------------------------------
str_to_int:
    xor rax, rax
.convert_loop:
    movzx rcx, byte [rdi]   ; lit le caractère
    test rcx, rcx
    jz .done                ; fin de chaîne => on sort
    sub rcx, '0'            ; convertit ASCII -> 0..9
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .convert_loop
.done:
    ret

; -------------------------------
; calculate_sum:
;   rdi = N
;   Calcule la somme 1 + 2 + ... + (N - 1).
;   Résultat dans rax.
; -------------------------------
calculate_sum:
    xor rax, rax      ; rax = 0 (somme)
    mov rcx, 1        ; rcx = 1 (compteur)

.sum_loop:
    cmp rcx, rdi      ; tant que rcx < N
    jge .sum_done
    add rax, rcx
    inc rcx
    jmp .sum_loop

.sum_done:
    ret

; -------------------------------
; display_number:
;   Affiche rdi en décimal,
;   suivi d’un saut de ligne.
; -------------------------------
display_number:
    mov rax, rdi          ; nombre à afficher dans rax

    ; On prépare un buffer temporaire
    mov rsi, buffer
    add rsi, 19
    mov byte [rsi], 0     ; terminaison de chaîne

    ; Cas où rax == 0 => afficher "0"
    test rax, rax
    jnz .convert_digits

    mov byte [buffer], '0'
    mov rax, 1            ; syscall write
    mov rdi, 1            ; fd = stdout
    mov rsi, buffer
    mov rdx, 1            ; longueur = 1
    syscall
    jmp .print_newline

.convert_digits:
    dec rsi
    mov rcx, 10

.digit_loop:
    xor rdx, rdx
    div rcx               ; rax / 10 => quotient dans rax, reste dans rdx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .digit_loop

    ; rsi pointe sur le 1er caractère
    inc rsi

    ; Affiche la chaîne => write(1, rsi, length)
    mov rax, 1
    mov rdi, 1
    mov rdx, buffer
    add rdx, 20
    sub rdx, rsi
    syscall

.print_newline:
    ; Saut de ligne
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

section .data
    newline db 10

section .bss
    buffer resb 20
