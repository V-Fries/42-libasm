; ssize_t'rax' ft_read(int fd'rdi', void* buf'rsi', size_t count'rdx');
global ft_read
ft_read:
    xor rax, rax
    syscall
    test rax, rax
    js .handle_errno
    ret

.handle_errno:
    push r12
    mov r12d, eax
    neg r12d
    call __errno_location wrt ..plt
    mov dword [rax], r12d
    mov rax, -1
    pop r12
    ret

extern __errno_location
