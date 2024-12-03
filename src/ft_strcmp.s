; int'eax'	ft_strcmp(const char *s1'rdi', const char *s2'rsi')
global ft_strcmp
ft_strcmp:
    xor eax, eax
    xor r11d, r11d

.loop:
    mov r10b, byte [rdi]
    mov al, r10b
    mov r11b, byte [rsi]
    sub eax, r11d
    js .return_negative
    jnz .return_positive

    test r10b, r10b
    jz .return

    inc rdi
    inc rsi

    jmp .loop

.return:
    ret

.return_negative
    mov eax, -1
    ret
.return_positive
    mov eax, 1
    ret


