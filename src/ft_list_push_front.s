%include "ft_list.mac"

struc vars
    .head: resq 1; t_list**
    .data: resq 1; void*

    .padding_for_stack_alignment: resq 1

    .size_of: resb 1
endstruc

%define head qword [rsp + vars.head]
%define data qword [rsp + vars.data]

;;; head MUST be a valid pointer
; void ft_list_push_front(t_list** head'rdi', void* data'rsi');
global ft_list_push_front
ft_list_push_front:
    sub rsp, vars.size_of
    mov head, rdi
    mov data, rsi

    mov rdi, t_list.size_of
    call malloc wrt ..plt
    test rax, rax
    jz .return

    mov rdi, head
    mov r10, [rdi]
    mov t_list_next(rax), r10

    mov rsi, data
    mov t_list_data(rax), rsi

    mov [rdi], rax

.return:
    add rsp, vars.size_of
    ret

extern malloc
