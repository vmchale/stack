%{#
#include <stdatomic.h>
%}

typedef aptr(l: addr) = $extype "atomic_intptr_t"

datavtype pointer_t(a: vt@ype) =
  | pointer_t of @{ pointer = [ l : addr | l > null ] (node_t(a) @ l, mfree_gc_v(l)| aptr(l)) }
  | none_t
and node_t(a: vt@ype) =
  | node_t of @{ value = a, next = pointer_t(a) }

vtypedef stack_t(a: vt@ype) = @{ stack_head = pointer_t(a) }

fun new {a:vt@ype} (&stack_t(a)? >> stack_t(a)) : void

fun push {a:vt@ype} (&stack_t(a) >> stack_t(a), a) : void

fun {a:vt@ype} pop (&stack_t(a) >> _, &a? >> Option_vt(a)) : void

fn {a:vt@ype} atmoic_store { l : addr | l > null }(a? @ l | aptr(l), a) : (a @ l | void) =
  "mac#"

fn {a:vt@ype} atomic_load { l : addr | l > null }(a @ l | aptr(l)) : a =
  "mac#"

// see: https://github.com/ivmai/libatomic_ops/blob/master/src/atomic_ops_stack.h
// uses libatomic
fn {a:vt@ype} atomic_malloc { sz : int | sz == sizeof(a) }(sz : size_t(sz)) :
  [l:addr] (a? @ l | aptr(l)) =
  "mac#malloc"
