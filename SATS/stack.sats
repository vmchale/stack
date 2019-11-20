typedef stack_t(a: type) = $extype "struct stack_t"

fun new {a:type}(&stack_t(a)? >> _) : void =
  "ext#new_ats"

fun push {a:type}(&stack_t(a) >> _, a) : void =
  "ext#push_ats"

fun pop {a:type}(&stack_t(a) >> _) : Option(a) =
  "ext#pop_ats"
