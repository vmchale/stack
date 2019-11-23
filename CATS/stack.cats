#include <stdatomic.h>
#include <stdlib.h>
#include <stdbool.h>

struct stack_t {
    void *value;
    struct stack_t *next;
};

void __cats_new(struct stack_t *st) {
    st->value = NULL;
    st->next = NULL;
}

void __cats_push(struct stack_t *st, void *val) {
    for (;;) {
        struct stack_t *pre_st = malloc(sizeof(pre_st));
        pre_st->value = st->value;
        pre_st->next = st->next;
        struct stack_t new_st = {val, pre_st};
        if (atomic_compare_exchange_strong(st, pre_st, new_st))
            return;
    }
}

// This DOES suffer the ABA problem, viz.
// http://15418.courses.cs.cmu.edu/spring2013/article/46,
// however, I think it's okay in our particular use case
void *__cats_pop(struct stack_t *st) {
    for (;;) {
        struct stack_t *pre_st = st;
        if (st->next == NULL)
            return NULL;
        struct stack_t *xs1 = st->next;
        void *x = st->value;
        if (atomic_compare_exchange_strong(st, pre_st, *xs1))
            return x;
    }
}

#ifdef PATS_CCOMP_CONFIG_H
atstype_boxed __cats_some(atstype_boxed val);
atstype_boxed __cats_none();

atstype_boxed pop_ats(atstype_ref st) {
    void *ret = __cats_pop(st);
    if (ret == NULL)
        return __cats_none();
    return __cats_some(ret);
}

atsvoid_t0ype new_ats(atstype_ref st) { __cats_new(st); }

atsvoid_t0ype push_ats(atstype_ref st, atstype_boxed val) {
    __cats_push(st, val);
}
#endif
