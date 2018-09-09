%{#
#include <stdatomic.h>
%}

// atomic_uintptr_t
typedef aptr(l: addr) = $extype "_Atomic char**"

datavtype pointer_t(a: vt@ype) =
  | pointer_t of node_t(a)
  | none_t
and node_t(a: vt@ype) =
  | node_t of @{ value = [ l : addr | l > null ] (a @ l | aptr(l))
               , next = pointer_t(a)
               }

vtypedef stack_t(a: vt@ype) = @{ stack_head = pointer_t(a) }

praxi copy_view {a:vt@ype}{l:addr} (a @ l) : (a @ l, a @ l)

fun copy_node {a:vt@ype} (node_t(a)) : (node_t(a), node_t(a))

fun copy_pointer {a:vt@ype} (pointer_t(a)) : (pointer_t(a), pointer_t(a))

fun copy_stack {a:vt@ype} (stack_t(a)) : (stack_t(a), stack_t(a))

fun new {a:vt@ype} (&stack_t(a)? >> stack_t(a)) : void

fun {a:vt@ype} push (&stack_t(a) >> stack_t(a), a) : void

fun {a:vt@ype} pop (&stack_t(a) >> _) : Option_vt(a)

fun newm {a:vt@ype} () : stack_t(a)

// push in the state monad
fun {a:vt@ype} pushm (stack_t(a), a) : stack_t(a)

// pop in the state monad
fun {a:vt@ype} popm (stack_t(a)) : (stack_t(a), Option_vt(a))

fn atomic_store {a:vt@ype}{ l : addr | l > null }(a? @ l | aptr(l), a) : (a @ l | void) =
  "mac#"

fn atomic_load {a:vt@ype}{ l : addr | l > null }(a @ l | aptr(l)) : a =
  "mac#"

fn atomic_malloc {a:vt@ype}{ sz : int | sz == sizeof(a) }(sz : size_t(sz)) :
  [ l : addr | l > null ] (a? @ l | aptr(l)) =
  "mac#malloc"
