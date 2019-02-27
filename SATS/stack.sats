%{#
#include <stdatomic.h>
%}

typedef aptr(l: addr) = $extype "_Atomic void**"

datavtype pointer_t(a: vt@ype) =
  | pointer_t of node_t(a)
  | none_t
and node_t(a: vt@ype) =
  | node_t of @{ value = [ l : addr | l > null ] (a @ l | aptr(l))
               , next = pointer_t(a)
               }

vtypedef stack_t(a: vt@ype) = @{ stack_head = pointer_t(a) }

castfn release_stack {a:vt@ype} (stack_t(a)) : void

fun new {a:vt@ype} (&stack_t(a)? >> stack_t(a)) : void

fun {a:vt@ype} push (&stack_t(a) >> stack_t(a), a) : void

fun {a:vt@ype} pop (&stack_t(a) >> _) : Option_vt(a)

fun newm {a:vt@ype} () : stack_t(a)

fn atomic_store {a:vt@ype}{ l : addr | l > null }(a? @ l | aptr(l), a) : (a @ l | void) =
  "mac#"

fn atomic_load {a:vt@ype}{ l : addr | l > null }(a @ l | aptr(l)) : a =
  "mac#"

fn unsafe_malloc {a:vt@ype}{ sz : int | sz == sizeof(a) }(sz : size_t(sz)) :
  [ l : addr | l > null ] (a? @ l | aptr(l)) =
  "mac#malloc"
