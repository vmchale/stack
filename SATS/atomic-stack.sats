typedef stack_t(a: t@ype+) = $extype "AO_stack_t"

// AO_stack_t *"
fun new {a:t@ype}(&stack_t(a)? >> _) : void =
  "ext#AO_stack_init_wrapper"

fun push {a:t@ype}(&stack_t(a) >> _, a) : void =
  "ext#AO_stack_push_wrapper"

fun pop {a:t@ype}(&stack_t(a) >> _) : Option(a) =
  "ext#AO_stack_pop_wrapper"
