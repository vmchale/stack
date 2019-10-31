datatype stack_t(a: t@ype+) =
  | cons of (a, stack_t(a))
  | nil

fn new {a:t@ype} (&stack_t(a)? >> stack_t(a)) : void

fun push {a:t@ype} (&stack_t(a) >> stack_t(a), a) : void

fun pop {a:t@ype} (&stack_t(a) >> stack_t(a)) : Option(a)

fn atomic_compare_exchange {a:t@ype}(&a >> _, a, a) : bool =
  "mac#atomic_compare_exchange_strong"
