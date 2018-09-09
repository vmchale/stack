staload "SATS/stack.sats"

#include "DATS/stack.dats"
#include "share/atspre_staload.hats"

vtypedef pair = @{ x = int, y = int }

implement main0 () =
  {
    val st = init()
    val st_r = ref(st)
    val x = @{ x = 1, y = 2 }
    val () = push<pair>(st_r, x)
  }
