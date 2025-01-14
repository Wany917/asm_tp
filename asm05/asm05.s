section .text
global _start

_start:
    ; Get argc from stack
    pop rax         ; Get argc
    pop rax         ; Skip argv[0] (program name)
    pop rdi         ; Get argv[1] (first argument)

    ; Calculate string length
    mov rcx, -1     ; Initialize counter
    mov al, 0       ; Search for null terminator
    cld             ; Clear direction flag
    repne scasb     ; Scan string
    not rcx         ; Invert counter
    dec rcx         ; Exclude null terminator
    
    ; Print the string
    mov rax, 1      ; sys_write
    mov rdi, 1      ; stdout
    mov rsi, rdi    ; Use the pointer we got from pop rdi earlier
    ; rcx already contains length
    syscall

    ; Exit program
    mov rax, 60     ; sys_exit
    xor rdi, rdi    ; return 0
    syscall