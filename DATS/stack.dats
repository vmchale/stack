staload "SATS/stack.sats"

implement new (st) =
  st.stack_head := none_t

implement {a} push (st, x) =
  let
    val (pf_pre | ptr) = atomic_malloc(sizeof<a>)
    val (pf | ()) = atomic_store(pf_pre | ptr, x)
    val next_node = node_t(@{ value = (pf | ptr), next = st.stack_head })
    val () = st.stack_head := pointer_t(next_node)
    
    extern
    praxi create_space_leak {a:vt@ype}{ l : addr | l > null } (a @ l) : void
  in end
