// typedef aptr(l: addr) = $extype "_Atomic void**"
// vtypedef aval(a: vt@ype+) = [ l : addr | l != null ] (a @ l | aptr(l))
abstype stack_t(a: t@ype+)

fun new {a:t@ype+} (&stack_t(a)? >> stack_t(a)) : void

fun {a:t@ype+} push (&stack_t(a) >> stack_t(a), a) : void

fun {a:t@ype+} pop (&stack_t(a) >> stack_t(a)) : Option(a)
