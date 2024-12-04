%include "ft_list.mac"

;;; List len MUST be less then i32::MAX
; int'eax' ft_list_size(const t_list* head'rdi');
global ft_list_size
ft_list_size:
    xor eax, eax
    test rdi, rdi
    jz .return

.loop:
    t_list_get_next rdi, rdi
    inc eax
    test rdi, rdi
    jnz .loop

.return:
    ret
