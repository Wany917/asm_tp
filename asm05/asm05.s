section .text
    global _start

_start:
    pop rax         ; Get argc
    cmp rax, 2      ; Check if we have at least one argument
    jl error        ; If not, jump to error

    pop rax         ; Skip argv[0]
    pop rdi         ; Get argv[1]

    ; Calculate string length
    mov rcx, -1     ; Initialize counter to -1
    xor al, al      ; al = 0 (searching for NULL)
    mov rsi, rdi    ; Copy string address
    repne scasb     ; Scan until NULL
    neg rcx         ; Get actual length
    dec rcx         ; Subtract 1 to exclude NULL

    ; Write to stdout
    mov rax, 1      ; syscall write
    mov rdi, 1      ; stdout
    mov rsi, [rsp-8]; Get back argv[1]
    mov rdx, rcx    ; length
    syscall

    mov rax, 60     ; syscall exit
    xor rdi, rdi    ; return 0
    syscall

error:
    mov rax, 60     ; syscall exit
    mov rdi, 1      ; return 1
    syscall