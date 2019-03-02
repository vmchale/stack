staload "SATS/stack.sats"

implement new (st) =
  st.stack_head := none_t

implement {a} push (st, x) =
  let
    val (pf_pre | ptr) = leaky_malloc(sizeof<a>)
    val (pf | ()) = atomic_store(pf_pre | ptr, x)
    var next_node = node_t(@{ value = (pf | ptr), next = st.stack_head })
    
    // TODO: should this be atomic?
    val () = st.stack_head := pointer_t(next_node)
  in end

// FIXME: this frees stuff unsafely, at least when working with multiple threads
// TODO: free none_t appropriately
implement {a} pop (st) =
  case+ st.stack_head of
    | @pointer_t (~node_t (nd)) => 
      begin
        let
          val (pf | aptr) = nd.value
          var x = atomic_load(pf | aptr)
          val () = free@(st.stack_head)
          val () = st.stack_head := nd.next
        in
          Some_vt(x)
        end
      end
    | none_t() => None_vt()
