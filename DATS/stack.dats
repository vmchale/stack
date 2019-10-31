staload "SATS/stack.sats"

implement new (st) =
  st := nil

implement push (st, x) =
  let
    var xs0 = st
    var xs1 = cons(x, xs0)
  in
    if atomic_compare_exchange(st, xs0, xs1) then
      ()
    else
      push(st, x)
  end

implement pop (st) =
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
