; asm_convert.s
; ---------------------------------------------
; Usage :
;   ./asm_convert 255
;       => Affiche la conversion hexa de 255 (FF)
;
;   ./asm_convert -b 42
;       => Affiche la conversion binaire de 42 (101010)
; ---------------------------------------------

section .text
global _start

_start:
    ; Récupération de argc dans rax
    mov rax, [rsp]        ; rax = argc

    ; On s’attend à 2 arguments => standard_convert
    ; ou 3 arguments => binary_convert
    cmp rax, 2
    je standard_convert
    cmp rax, 3
    je binary_convert
    jmp error_param

; -------------------------------------------------------------------
; standard_convert: 
;   ./asm_convert 255
;   => convertit 255 (argv[1]) en hexadécimal
; -------------------------------------------------------------------
standard_convert:
    ; argv[1] = [rsp + 16]
    mov rsi, [rsp + 16]
    mov rdi, rsi
    call str_to_int       ; => rax contient le nombre
    mov rdi, rax          ; on met le nombre dans rdi
    call dec_to_hex
    jmp exit_success

; -------------------------------------------------------------------
; binary_convert:
;   ./asm_convert -b 42
;   => convertit 42 (argv[2]) en binaire
; -------------------------------------------------------------------
binary_convert:
    ; On s’attend à ce que argv[1] == "-b"
    ; argv[1] = [rsp + 16]
    mov rsi, [rsp + 16]
    cmp byte [rsi], '-'
    jne error_param
    cmp byte [rsi + 1], 'b'
    jne error_param

    ; argv[2] = [rsp + 24]
    mov rsi, [rsp + 24]
    mov rdi, rsi
    call str_to_int       ; => rax
    mov rdi, rax
    call dec_to_bin
    jmp exit_success

; -------------------------------------------------------------------
; str_to_int
;  Convertit la chaîne pointée par rdi en entier décimal (base 10).
;  Retourne le résultat dans rax.
; -------------------------------------------------------------------
str_to_int:
    xor rax, rax
.convert_loop:
    movzx rcx, byte [rdi]
    test rcx, rcx
    jz .done            ; fin de chaîne => on sort
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .convert_loop
.done:
    ret

; -------------------------------------------------------------------
; dec_to_hex
;  Convertit le nombre (en rdi) en hexadécimal et l’affiche,
;  suivi d’un saut de ligne.
; -------------------------------------------------------------------
dec_to_hex:
    mov rax, rdi         ; rax = valeur à convertir
    mov rsi, buffer
    add rsi, 19
    mov byte [rsi], 0    ; terminaison de chaîne

    dec rsi
    mov rcx, 16

.hex_loop:
    xor rdx, rdx
    div rcx              ; rax / 16, reste dans rdx
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

    ; Appel système write(1, rsi, longueur)
    mov rax, 1           ; syscall write
    mov rdi, 1           ; fd=1 (stdout)
    ; rsi pointe déjà sur le début de la chaîne
    mov rdx, buffer
    add rdx, 20          ; rdx = fin buffer
    sub rdx, rsi         ; longueur = (fin) - (début)
    syscall

    ; Saut de ligne
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

; -------------------------------------------------------------------
; dec_to_bin
;  Convertit le nombre (en rdi) en binaire et l’affiche,
;  suivi d’un saut de ligne.
; -------------------------------------------------------------------
dec_to_bin:
    mov rax, rdi
    mov rsi, buffer
    add rsi, 19
    mov byte [rsi], 0

    dec rsi
    mov rcx, 2

.bin_loop:
    xor rdx, rdx
    div rcx              ; rax / 2, reste dans rdx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .bin_loop

    inc rsi

    ; Appel système write(1, rsi, longueur)
    mov rax, 1           ; syscall write
    mov rdi, 1           ; fd=1 (stdout)
    ; rsi = début de la chaîne convertie
    mov rdx, buffer
    add rdx, 20
    sub rdx, rsi
    syscall

    ; Saut de ligne
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

; -------------------------------------------------------------------
; error_param: quitter avec code 1
; -------------------------------------------------------------------
error_param:
    mov rax, 60    ; syscall exit
    mov rdi, 1     ; code de sortie = 1
    syscall

; -------------------------------------------------------------------
; exit_success: quitter avec code 0
; -------------------------------------------------------------------
exit_success:
    mov rax, 60
    xor rdi, rdi   ; rdi=0
    syscall

section .data
    newline db 10

section .bss
    buffer resb 20
