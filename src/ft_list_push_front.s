%include "ft_list.mac"

;;; head MUST be a valid pointer
; void ft_list_push_front(t_list** head'rdi', void* data'rsi');
global ft_list_push_front
ft_list_push_front:
    sub rsp, 16
    mov [rsp], rdi
    mov [rsp + 8], rsi

    mov rdi, t_list.size_of
    call malloc wrt ..plt

    mov rdi, [rsp]
    mov rsi, [rsp + 8]
    add rsp, 16

    test rax, rax
    jz .return

    mov r10, [rdi]
    mov t_list_next(rax), r10
    mov t_list_data(rax), rsi
    mov [rdi], rax

.return:
    ret

extern malloc
