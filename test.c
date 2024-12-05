#include <stdlib.h>

typedef struct s_list {
    void* data;
    struct s_list* next;
} t_list;

void ft_list_sort(
    t_list** head,
    int (*cmp)(void*, void*)
);


void ft_list_push_front(t_list** head, void* data);

int cmp(void* i1, void* i2) {
    return i1 - i2;
}

#define NB 5

int main(void) {
    t_list* list = NULL;
    for (size_t i = 0; i < NB; ++i) {
        ft_list_push_front(&list, (void*)i);
    }

    t_list* cursor = list;
    for (ssize_t i = NB - 1; i >= 0; --i) {
        if (cursor->data != (void*)i) {
            exit(i);
        }
        cursor = cursor->next;
    }
    ft_list_sort(&list, cmp);
    cursor = list;
    for (size_t i = 0; i < NB; ++i) {
        if (cursor == NULL) { exit(255); }
        if (cursor->data != (void*)i) {
            exit(100 + i);
        }
        cursor = cursor->next;
    }

    cursor = list;
    while (cursor != NULL) {
        t_list* next = cursor;
        free(cursor);
        cursor = next;
    }
}
