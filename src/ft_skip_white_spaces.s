extern ft_isspace

;;; str MUST be a valid nul terminated string
;;; return ptr MUST not be freed
;const char*'rax' ft_skip_white_spaces(const char*str'rdi')
global ft_skip_white_spaces
ft_skip_white_spaces:
    push r12

    mov r12, rdi
    xor edi, edi


    mov dil, byte [r12]
    test dil, dil
    jz .return
    call ft_isspace
    test eax, eax
    jz .return
.loop:
    inc r12
    mov dil, byte [r12]
    test dil, dil
    jz .return
    call ft_isspace
    test eax, eax
    jnz .loop

.return:
    mov rax, r12

    pop r12
    ret
