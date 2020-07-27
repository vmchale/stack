typedef stack_t(a: type) = $extype "AO_stack_t"

// AO_stack_t *"
fun new {a:type}(&stack_t(a)? >> _) : void =
  "ext#AO_stack_init_wrapper"

fun push {a:type}(&stack_t(a) >> _, a) : void =
  "ext#AO_stack_push_wrapper"

fun pop {a:type}(&stack_t(a) >> _) : Option(a) =
  "ext#AO_stack_pop_wrapper"
