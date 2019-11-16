typedef stack_t(a: t@ype+) = $extype "struct stack_t"

fun new {a:t@ype+}(&stack_t(a)? >> _) : void =
  "ext#new_ats"

fun push {a:t@ype+}(&stack_t(a) >> _, a) : void =
  "ext#push_ats"

fun pop {a:t@ype+}(&stack_t(a) >> _) : Option(a) =
  "ext#pop_ats"
