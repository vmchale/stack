#include <stdlib.h>

atstype_boxed __cats_some(atstype_boxed val);
atstype_boxed __cats_none();

atsvoid_t0ype AO_stack_init_wrapper(atstype_ref st) {
    AO_stack_init(st);
}

atsvoid_t0ype AO_stack_push_wrapper(atstype_ref st, atstype_boxed val) {
    AO_stack_push((AO_stack_t*) st, val);
}

atstype_boxed AO_stack_pop_wrapper(atstype_ref st) {
    void *ret = AO_stack_pop((AO_stack_t*) st);
    if (ret == NULL)
        return __cats_none();
    return __cats_some(ret);
}
