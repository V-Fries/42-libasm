%define UNINIT_BASE_CHAR_MAP_ELEM -1

%define BASE_CHAR_MAP_ELEM_SIZE 2

extern ft_isspace
extern ft_skip_white_spaces

struc Vars
    .str: resq 1; const char*
    .base: resq 1; const char*
    .base_char_map: resw 256; u16[256]
    .base_len: resq 1; usize

    .padding_for_stack_alignment: resb 0

    .size_of: resb 0
endstruc


%define Vars.str(ptr) qword [ptr + Vars.str]
%define Vars.base(ptr) qword [ptr + Vars.base]


%define base_char_map_content(base_char_map, char) word [base_char_map + char * BASE_CHAR_MAP_ELEM_SIZE]

%define Vars.base_len(ptr) qword [ptr + Vars.base_len]

;void init_vars(
;   const char* str'rdi',
;   const char* base'rsi',
;   Vars* vars'rdx',
;);
init_vars:
    mov Vars.str(rdx), rdi
    mov Vars.base(rdx), rsi

    mov r10, rdx
    add r10, Vars.base_char_map
    mov r11, r10
    add r11, 256 * BASE_CHAR_MAP_ELEM_SIZE

.init_vars.loop:
    mov word [r10], UNINIT_BASE_CHAR_MAP_ELEM
    add r10, BASE_CHAR_MAP_ELEM_SIZE
    cmp r11, r10
    jne .init_vars.loop

    ret


struc VarsCheckBase
    .rbx_save: resq 1; const char*
    .r14_save: resq 1; u16*
    .r15_save: resq 1; usize*

    .r12_save: resq 1; usize
    .r13_save: resq 1; char

    .padding_for_stack_alignment: resb 0

    .size_of: resb 0
endstruc

%define VarsCheckBase.rbx_save(ptr) qword [ptr + VarsCheckBase.rbx_save]
%define VarsCheckBase.r14_save(ptr) qword [ptr + VarsCheckBase.r14_save]
%define VarsCheckBase.r15_save(ptr) qword [ptr + VarsCheckBase.r15_save]
%define VarsCheckBase.r12_save(ptr) qword [ptr + VarsCheckBase.r12_save]
%define VarsCheckBase.r13_save(ptr) qword [ptr + VarsCheckBase.r13_save]

;;; base is a pointer to valid nul terminated string
;;; base_char_map is a pointer to an u16 array of size 256
;;; return 0 if base is valid
;bool'al' check_base(
;   const char* base'rdi',
;   u16* base_char_map'rsi',
;   usize* base_len'rdx'
;);
check_base:
    sub rsp, VarsCheckBase.size_of

    mov VarsCheckBase.rbx_save(rsp), rbx
    mov VarsCheckBase.r14_save(rsp), r14
    mov VarsCheckBase.r15_save(rsp), r15
    mov VarsCheckBase.r12_save(rsp), r12
    mov VarsCheckBase.r13_save(rsp), r13

    mov rbx, rdi
    mov r14, rsi
    mov r15, rdx

    xor r12, r12
    xor r13, r13

.loop:
    mov r13b, byte [rbx + r12]

    test r13b, r13b
    jz .loop_end

    cmp r13b, '-'
    je .return_1

    cmp r13b, '+'
    je .return_1

    mov edi, r13d
    call ft_isspace
    test eax, eax
    jnz .return_1

    mov r8w, base_char_map_content(r14, r13)
    cmp r8w, UNINIT_BASE_CHAR_MAP_ELEM
    jne .return_1

    mov base_char_map_content(r14, r13), r12w

    inc r12
    jmp .loop
.loop_end:

    cmp r12, 2
    jb .return_1
    mov [r15], r12
    xor al, al
    jmp .restore_stack_and_ret

.return_1:
    mov al, 1

.restore_stack_and_ret:
    mov rbx, VarsCheckBase.rbx_save(rsp)
    mov r14, VarsCheckBase.r14_save(rsp)
    mov r15, VarsCheckBase.r15_save(rsp)
    mov r12, VarsCheckBase.r12_save(rsp)
    mov r13, VarsCheckBase.r13_save(rsp)
    add rsp, VarsCheckBase.size_of
    ret

;bool'rax' is_negative_and_skip_signs(
;   const char** nb'rdi'
;);
is_negative_and_skip_signs:
    xor rax, rax; - count
    mov r10, [rdi]
    
.loop:
    mov r11b, byte [r10]
    test r11b, r11b
    jz .end_loop
    cmp r11b, '-'
    jne .not_minus
    inc rax
    inc r10
    jmp .loop
.not_minus:
    cmp r11b, '+'
    jne .end_loop
    inc r10
    jmp .loop

.end_loop:
    mov [rdi], r10
    and rax, 1
    ret


;int'eax' convert_to_number(
;   char* str'rdi',
;   u16* base_char_map'rsi',
;   usize base_len'rdx',
;   bool is_negative'rcx'
;);
convert_to_number:
    xor r10, r10; current char
    xor eax, eax
    xor r11d, r11d

.loop:
    mov r10b, byte [rdi]
    test r10b, r10b
    jz .end_loop
    mov r11w, base_char_map_content(rsi, r10)
    cmp r11w, UNINIT_BASE_CHAR_MAP_ELEM
    je .end_loop
    imul eax, edx
    add eax, r11d
    inc rdi
    jmp .loop

.end_loop:
    test rcx, rcx
    jz .return
    neg eax
.return:
    ret

;;; str MUST be a valid nul terminated string
;;; The number stored in str SHOULD be in the range of an int32
;;; base MUST be a valid nul terminated string
;;; base char SHOULD NOT be '+' / '-' / whitespace
;;; base char SHOULD all be unique
;;; base len SHOULD be at least 2
; int'eax' ft_atoi_base(
;   const char* str'rdi',
;   const char* base'rsi'
;);
global ft_atoi_base
ft_atoi_base:
    sub rsp, Vars.size_of

    ; mov rdi, rdi
    ; mov rsi, rsi
    mov rdx, rsp
    call init_vars
    ; returns void

    mov rdi, Vars.base(rsp)
    mov rsi, rsp
    add rsi, Vars.base_char_map
    mov rdx, rsp
    add rdx, Vars.base_len
    call check_base
    test al, al
    jnz .return_0

    mov rdi, Vars.str(rsp)
    call ft_skip_white_spaces
    mov Vars.str(rsp), rax

    mov rdi, rsp
    add rdi, Vars.str
    call is_negative_and_skip_signs

    mov rdi, Vars.str(rsp)
    mov rsi, rsp
    add rsi, Vars.base_char_map
    mov rdx, Vars.base_len(rsp)
    mov rcx, rax
    call convert_to_number

    add rsp, Vars.size_of
    ret

.return_0:
    add rsp, Vars.size_of
    xor eax, eax
    ret

