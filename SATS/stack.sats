%{#
#include <stdatomic.h>
%}

typedef aptr(l: addr) = $extype "atomic_intptr_t"

datavtype pointer_t(a: vt@ype) =
  | pointer_t of node_t(a)
  | none_t
and node_t(a: vt@ype) =
  | node_t of @{ value = [l:addr] (a @ l | aptr(l)), next = pointer_t(a) }

vtypedef stack_t(a: vt@ype) = @{ stack_head = pointer_t(a) }

fun new {a:vt@ype} (&stack_t(a)? >> stack_t(a)) : void

fun {a:vt@ype} push (&stack_t(a) >> stack_t(a), a) : void

fun {a:vt@ype} pop (&stack_t(a) >> _, &a? >> Option_vt(a)) : void

fn atomic_store {a:vt@ype}{ l : addr | l > null }(a? @ l | aptr(l), a) : (a @ l | void) =
  "mac#"

fn {a:vt@ype} atomic_load { l : addr | l > null }(a @ l | aptr(l)) : a =
  "mac#"

// strictly speaking it is wrong to assert it isn't null but idc
fn {a:vt@ype} atomic_malloc { sz : int | sz == sizeof(a) }(sz : size_t(sz)) :
  [ l : addr | l > null ] (a? @ l | aptr(l)) =
  "mac#malloc"
