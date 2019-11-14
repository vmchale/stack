typedef stack_t(a: t@ype+) = $extype "struct stack_t"

fun new {a:t@ype+}(&stack_t(a)? >> stack_t(a)) : void =
  "ext#"

fun push {a:t@ype+}(&stack_t(a) >> stack_t(a), a) : void =
  "ext#"

fun pop {a:t@ype+}(&stack_t(a) >> stack_t(a)) : Option(a) =
  "ext#"
