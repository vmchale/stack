%{#
#include <stdatomic.h>
%}

datatype stack_t(a: type+) =
  | cons of (a, stack_t(a))
  | nil of ()

fun new {a:type} (&stack_t(a)? >> stack_t(a)) : void

fun {a:type} push (&stack_t(a) >> stack_t(a), a) : void

fun {a:type} pop (&stack_t(a) >> stack_t(a)) : Option(a)

fn atomic_compare_exchange {a:type}(&a >> _, a, a) : bool =
  "ext#atomic_compare_exchange_strong"
