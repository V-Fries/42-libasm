; char*'rax' ft_strdup(const char* str'rdi');
global ft_strdup
ft_strdup:
    push rdi

    ; rdi same as for current fn
    call ft_strlen

    mov rdi, rax
    inc rdi
    ; See the following to understand the call
    ; PIE (Position-independent code)
    ; PLT (Procedure Linkage Table)
    ; GOT (Global Offset Table)
    call malloc wrt ..plt
    ; also works:
    ; call [rel malloc wrt ..plt]
    ; call malloc wrt ..got
    ; call [rel malloc wrt ..got]

    pop rsi ; Clean stack and set arg for ft_strcpy

    test rax, rax
    jnz .malloc_success
    ret

.malloc_success:
    mov rdi, rax
    jmp ft_strcpy


extern malloc
extern ft_strlen
extern ft_strcpy
