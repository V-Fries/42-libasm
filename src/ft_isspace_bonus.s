%include "bool.mac"

; int'eax' ft_isspace(char c'edi');
global ft_isspace
ft_isspace:
    cmp edi, 9
    jl .return_false
    cmp edi, 14
    jl .return_true
    cmp edi, ' '
    jne .return_false

.return_true:
    mov eax, TRUE
    ret

.return_false:
    xor eax, eax
    ret
