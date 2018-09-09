staload "SATS/stack.sats"

implement copy_node (node) =
  let
    val ~node_t (nd) = node
    val node_next = nd.next
    val (node_next0, node_next1) = copy_pointer(node_next)
    val (node_pf | node_ptr) = nd.value
    prval (node_pf0, node_pf1) = copy_view(node_pf)
    val node0 = node_t(@{ value = (node_pf0 | node_ptr), next = node_next0 })
    val node1 = node_t(@{ value = (node_pf1 | node_ptr), next = node_next1 })
  in
    (node0, node1)
  end

implement copy_pointer (ptr) =
  case+ ptr of
    | ~none_t() => (none_t, none_t)
    | ~pointer_t (nd) => let
      val (nd0, nd1) = copy_node(nd)
    in
      (pointer_t(nd0), pointer_t(nd1))
    end

implement copy_stack (st) =
  let
    val ptr = st.stack_head
    val (ptr0, ptr1) = copy_pointer(ptr)
    val st0 = @{ stack_head = ptr0 }
    val st1 = @{ stack_head = ptr1 }
  in
    (st0, st1)
  end

implement newm () =
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

implement {a} pushm (st, x) =
  let
    val (pf_pre | ptr) = atomic_malloc(sizeof<a>)
    val (pf | ()) = atomic_store(pf_pre | ptr, x)
    val next_node = node_t(@{ value = (pf | ptr), next = st.stack_head })
  in
    @{ stack_head = pointer_t(next_node) }
  end

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

implement {a} popm (st) =
  case+ st.stack_head of
    | ~pointer_t (~node_t (nd)) => 
      begin
        let
          val (pf | aptr) = nd.value
          val x = atomic_load(pf | aptr)
          val new_st = @{ stack_head = nd.next }
        in
          (new_st, Some_vt(x))
        end
      end
    | ~none_t() => let
      val new_st = @{ stack_head = none_t }
    in
      (new_st, None_vt())
    end
