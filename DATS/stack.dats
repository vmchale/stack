staload "SATS/stack.sats"

implement new (st) =
  st.stack_head := none_t

implement {a} push (st, x) =
  let
    val (pf_pre, pf_free | ptr) = amalloc(sizeof<a>)
    val (pf | ()) = atomic_store(pf_pre | ptr, x)
    var next_node = node_t(@{ value = (pf, pf_free | ptr), next = st.stack_head })
    
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
          val (pf, pf_free | aptr) = nd.value
          var x = atomic_load(pf, pf_free | aptr)
          val () = free@(st.stack_head)
          val () = st.stack_head := nd.next
        in
          Some_vt(x)
        end
      end
    | none_t() => None_vt()
