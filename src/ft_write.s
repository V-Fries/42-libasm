; ssize_t'rax' ft_write(int fildes'rdi', const void* buf'rsi', size_t nbyte'rdx');
global ft_write
ft_write:
    mov rax, 1
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
