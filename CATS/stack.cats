#include <stdatomic.h>
#include <stdlib.h>

struct stack_t {
    void *value;
    struct stack_t *next;
};

void __cats_new (struct stack_t *st) {
    st->value = NULL;
    st->next = NULL;
}

void __cats_push(struct stack_t *st, void *val) {
    for (;;) {
        struct stack_t old_st = *st;
        struct stack_t new_st = {val, &old_st};
        if (atomic_compare_exchange_strong(st, &old_st, new_st))
            return;
    }
}

void *__cats_pop(struct stack_t *st) {
    for (;;) {
        if (st->next == NULL)
            return NULL;
        struct stack_t *old_st = st;
        struct stack_t xs1 = *(st->next);
        void *x = st->value;
        if (atomic_compare_exchange_strong(st, old_st, xs1))
            return x;
    }
}

#ifdef PATS_CCOMP_CONFIG_H
atstype_boxed pop_ats(atstype_ref st) {
    return __cats_pop(st);
}

atsvoid_t0ype new_ats(atstype_ref st) {
    __cats_new(st);
}

atsvoid_t0ype push_ats(atstype_ref st, atstype_var val) {
    __cats_push(st, val);
}
#endif
