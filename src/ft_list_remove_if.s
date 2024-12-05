%include "ft_list.mac"
%include "utils.mac"

extern free

struc vars
    .head: resq 1; t_list**
    .data_ref: resq 1; void*
    .cmp_fn: resq 1; int (*)(void*, void*)
    .free_fct_fn: resq 1; void (*)(void*)

    .previous_node: resq 1; t_list*
    .cursor: resq 1; t_list*

    .padding_for_stack_alignment: resq 1

    .size_of: resb 1
endstruc

%define head qword [rsp + vars.head]
%define data_ref qword [rsp + vars.data_ref]
%define cmp_fn qword [rsp + vars.cmp_fn]
%define free_fct_fn qword [rsp + vars.free_fct_fn]

%define previous_node qword [rsp + vars.previous_node]
%define cursor qword [rsp + vars.cursor]

;;; head MUST be a valid pointer
;;; cmp MUST be a valid pointer
;;; free_fct MAY be NULL
; void ft_list_remove_if(
;    t_list** head'rdi',
;    void* data_ref'rsi',
;    int'eax' (*cmp'rdx')(void*'rdi', void*'rsi'),
;    void (*free_fct'rcx')(void*'rdi')
; );
global ft_list_remove_if
ft_list_remove_if:
    mov r10, [rdi]
    test r10, r10
    jz .return

    sub rsp, vars.size_of

    mov head, rdi
    mov data_ref, rsi
    mov cmp_fn, rdx
    mov free_fct_fn, rcx

    mov previous_node, NULL
    ; cursor can't be NULL as r10 was checked above
    mov cursor, r10

	.loop: ; do while cursor != NULL	
		;if_1 cmp(cursor->data, data_ref) != 0
		        mov rdi, cursor
		        mov rdi, t_list_data(rdi)
		        mov rsi, data_ref
		        call cmp_fn
		        test eax, eax
		        jz .if_1_end
            ; previous_node = cursor;
            ; cursor = cursor->next;
			mov r10, cursor
		    mov previous_node, r10
		    mov r10, t_list_next(r10)
		    mov cursor, r10
            ; continue
	        cmp cursor, NULL
	        jnz .loop
            jmp .loop_end
        .if_1_end:

	    ;if_2 previous_node != NULL
	            cmp previous_node, NULL
	            jz .if_2_else
            ; previous_node->next = cursor->next;
            mov r11, cursor
            mov r11, t_list_next(r11)
            mov r10, previous_node
            mov t_list_next(r10), r11
            jmp .if_2_end
	    .if_2_else:
            ; *head = cursor->next
            mov r11, cursor
            mov r11, t_list_next(r11)
            mov r10, head
            mov [r10], r11
        .if_2_end:

        ; if_3 free_fct != NULL
                cmp free_fct_fn, NULL
                jz .if_3_end
            ; free_fct(cursot->content);
            mov rdi, cursor
            mov rdi, t_list_data(rdi)
            call free_fct_fn
        .if_3_end:

        mov rdi, cursor
        call free wrt ..plt

        ;if_4 previous_node != NULL
	            cmp previous_node, NULL
	            jz .if_4_else
            ;cursor = previous_node->next
            mov r10, previous_node
            mov r10, t_list_next(r10)
            mov cursor, r10
            jmp .if_4_end
        .if_4_else:
            ;cursor = *head;
            mov r10, head
            mov r10, [r10]
            mov cursor, r10
        .if_4_end:

	    cmp cursor, NULL
	    jnz .loop
    .loop_end:
	
    add rsp, vars.size_of
    .return:
    ret
