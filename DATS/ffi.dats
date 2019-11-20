extern
fun none {a:type}() : Option(a) =
  "ext#__cats_none"

extern
fun some {a:type}(a) : Option(a) =
  "ext#__cats_some"

implement none () =
  None()

implement some (x) =
  Some(x)
