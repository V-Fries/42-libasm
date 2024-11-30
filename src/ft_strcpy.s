%macro copy_byte_from_ptrs 2
    mov r10b, byte [%2]
    mov byte [%1], r10b
%endmacro

; char*'rax' ft_strcpy(char* dest'rdi', const char* src'rsi');
global ft_strcpy
ft_strcpy:
    mov rax, rdi

    copy_byte_from_ptrs rdi, rsi
    cmp byte [rdi], 0
    jnz .loop
    ret

.loop:
    inc rdi
    inc rsi
    copy_byte_from_ptrs rdi, rsi
    cmp byte [rdi], 0
    jnz .loop
    ret
