staload "SATS/stack.sats"

implement new (st) =
  st := nil()

implement {a} push (st, x) =
  let
    var xs0 = st
    var xs1 = cons(x, xs0)
  in
    if atomic_compare_exchange(st, xs0, xs1) then
      ()
    else
      push(st, x)
  end

// FIXME: this frees stuff unsafely, at least when working with multiple threads
// TODO: free none_t appropriately
implement {a} pop (st) =
  let
    var xs0 = st
  in
    case+ xs0 of
      | nil() => None()
      | cons (x, xs1) => if atomic_compare_exchange(st, xs0, xs1) then
        Some(x)
      else
        pop(st)
  end
