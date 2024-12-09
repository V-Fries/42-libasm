%include "ft_list.mac"
%include "utils.mac"

struc vars
    .head: resq 1; t_list**
    .cmp_fn: resq 1; int (*)(void*, void*)

    .left: resq 1; t_list*
    .right: resq 1; t_list*
    .cursor: resq 1; t_list*
    .next: resq 1; t_list*

    .padding_for_stack_alignment: resq 1

    .size_of: resb 1
endstruc


%define head qword [rsp + vars.head]
%define cmp_fn qword [rsp + vars.cmp_fn]

%define left qword [rsp + vars.left]
%define right qword [rsp + vars.right]
%define cursor qword [rsp + vars.cursor]
%define next qword [rsp + vars.next]


%macro move_node 1
    ;next = cursor->next;
    mov r10, cursor
    mov r11, t_list_next(r10)
    mov next, r11

    ;cursor->next = %1;
    mov r11, %1
    mov t_list_next(r10), r11

    ;%1 = cursor;
    mov %1, r10

    ;cursor = next;
    mov r11, next
    mov cursor, r11
%endmacro


%macro set_head_and_cursor 1
    ;*head = %1
    mov r10, head
    mov r11, %1
    mov [r10], r11

    ;%1 = %1->next
    mov r11, t_list_next(r11)
    mov %1, r11

    ;cursor = *head
    mov r10, [r10]
    mov cursor, r10
%endmacro


%macro push_smallest_node 1
    ;cursor->next = %1
    mov r10, cursor
    mov r11, %1
    mov t_list_next(r10), r11

    ;cursor = %1
    mov cursor, r11

    ;%1 = %1->next
    mov r11, t_list_next(r11)
    mov %1, r11
%endmacro


%macro call_cmp_fn 0
    mov rdi, left
    mov rdi, t_list_data(rdi)
    mov rsi, right
    mov rsi, t_list_data(rsi)
    call cmp_fn
%endmacro


%macro check_exit_conditions 0
    ;if *head == NULL { return }
    mov r10, [rdi]
    test r10, r10
    jz .return
    ;if (*head)->next == NULL { return }
    mov r9, t_list_next(r10)
    test r9, r9
    jz .return
%endmacro


%macro init_vars 0
    ; Make space for args and vars
    sub rsp, vars.size_of

    ; Put args on stack
    mov head, rdi
    mov cmp_fn, rsi

    ;t_list* left = *head
    mov left, r10
    ;t_list* right = (*head)->next
    mov right, r9
    ;t_list* cursor = right->next
    mov r11, t_list_next(r9)
    mov cursor, r11

    ;left->next = NULL
    mov t_list_next(r10), NULL
    ;right->next = NULL
    mov t_list_next(r9), NULL
%endmacro


%macro seperate_list_in_left_and_right 0
    cmp cursor, NULL
    jz .loop_1_end
.loop_1: ;while cursor != NULL
    move_node left
    cmp cursor, NULL
    jz .loop_1_end
    move_node right
    cmp cursor, NULL
    jnz .loop_1
.loop_1_end:
%endmacro


%macro sort_left_and_right_with_recursion 0
    ;ft_list_sort(&left, cmp)
    mov rdi, rsp
    add rdi, vars.left
    mov rsi, cmp_fn
    call ft_list_sort
    ;ft_list_sort(&right, cmp)
    mov rdi, rsp
    add rdi, vars.right
    mov rsi, cmp_fn
    call ft_list_sort
%endmacro


%macro merge_left_and_right_into_head 0
    ;cmp(left->data, right->data)
    call_cmp_fn
    test eax, eax
    jns .left_bigger_than_right
    set_head_and_cursor left
    jmp .end_if
.left_bigger_than_right:
    set_head_and_cursor right
.end_if:

    cmp left, NULL
    jz .loop_2_end
    cmp right, NULL
    jz .loop_2_end
.loop_2: ;left != NULL && right != NULL
    call_cmp_fn
    test eax, eax
    jns .left_bigger_than_right_2
    push_smallest_node left
    jmp .end_if_2
.left_bigger_than_right_2:
    push_smallest_node right
.end_if_2:
    cmp left, NULL
    jz .loop_2_end
    cmp right, NULL
    jnz .loop_2
.loop_2_end:

    ;if left != NULL
    cmp left, NULL
    jz .left_is_empty
    ;cursor->next = left
    mov r11, left
    jmp .end_if_3
.left_is_empty:
    ;cursor->next = right
    mov r11, right
.end_if_3:
    mov r10, cursor
    mov t_list_next(r10), r11
%endmacro


%macro destroy_vars 0
    add rsp, vars.size_of
%endmacro


;;; head MUST be a valid pointer
;;; cmp MUST be a valid pointer
; void ft_list_sort(
;    t_list** head'rdi',
;    int'eax' (*cmp'rsi')(void*'rdi', void*'rsi'),
; );
global ft_list_sort
ft_list_sort:
    check_exit_conditions

    init_vars

    seperate_list_in_left_and_right

    sort_left_and_right_with_recursion

    merge_left_and_right_into_head

    destroy_vars
.return:
    ret
