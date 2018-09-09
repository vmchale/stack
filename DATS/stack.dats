staload "SATS/stack.sats"

implement init () =
  @{ stack_head = none_t }

implement new (st) =
  st.stack_head := none_t

implement {a} push (st, x) =
  let
    val (pf_pre | ptr) = atomic_malloc(sizeof<a>)
    val (pf | ()) = atomic_store(pf_pre | ptr, x)
    val next_node = node_t(@{ value = (pf | ptr), next = st.stack_head })
    val () = st.stack_head := pointer_t(next_node)
  in end

implement {a} pop (st) =
  case+ st.stack_head of
    | ~pointer_t (~node_t (nd)) => 
      begin
        let
          val (pf | aptr) = nd.value
          val x = atomic_load(pf | aptr)
          val () = st.stack_head := nd.next
        in
          Some_vt(x)
        end
      end
    | none_t() => None_vt()
