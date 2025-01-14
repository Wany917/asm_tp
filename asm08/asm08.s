section .bss
    number resb 10
    binary resb 33

section .text
    global _start

_start:
    ; Lire l'entrée de l'utilisateur
    mov eax, 3
    mov ebx, 0
    mov ecx, number
    mov edx, 10
    int 0x80

    ; Convertir la chaîne de caractères en nombre décimal
    mov ecx, number
    xor eax, eax

convert_decimal:
    mov dl, byte [ecx]
    sub dl, '0'         ; Convertir le caractère ASCII en chiffre
    cmp dl, 10
    jae done_conversion
    imul eax, 10
    add eax, edx
    inc ecx
    jmp convert_decimal

done_conversion:
    ; Préparer la conversion en binaire
    mov ecx, 32
    lea edi, [binary+31]

convert_binary:
    xor edx, edx
    mov ebx, 2
    div ebx             ; Diviser eax par 2
    add dl, '0'         ; Convertir le reste en caractère ASCII
    dec edi
    mov [edi], dl
    dec ecx
    test eax, eax
    jnz convert_binary

    ; Afficher le résultat binaire
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    lea edx, [binary+32]
    sub edx, edi
    int 0x80

    ; Terminer le programme
    mov eax, 1
    mov rdi, 0
    int 0x80
