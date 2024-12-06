%macro sub_byte 0
    mov r10b, byte [rdi]
    mov eax, r10d
    mov r11b, byte [rsi]
    sub eax, r11d
%endmacro

;;; s1 MUST be a valid nul terminated string
;;; s2 MUST be a valid nul terminated string
; int'eax'	ft_strcmp(const char *s1'rdi', const char *s2'rsi')
global ft_strcmp
ft_strcmp:
    xor r10d, r10d
    xor r11d, r11d

    sub_byte
    js .return_negative
    jnz .return_positive
    test r10b, r10b
    jz .return

.loop:
    inc rdi
    inc rsi

    sub_byte
    js .return_negative
    jnz .return_positive
    test r10b, r10b
    jnz .loop

.return:
    ret

.return_positive:
    mov eax, 1
    ret

.return_negative:
    mov eax, -1
    ret
