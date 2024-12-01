; size_t'rax' ft_strlen(const char* str'rdi');
global ft_strlen
ft_strlen:
    cmp byte [rdi], 0
    jz .return_zero

    mov rax, rdi

.loop:
    inc rax
    cmp byte [rax], 0
    jnz .loop

    sub rax, rdi
    ret

.return_zero:
    xor rax, rax
    ret
