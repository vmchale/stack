staload "SATS/stack.sats"
staload "libats/ML/SATS/string.sats"

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
#include "DATS/stack.dats"

typedef pair = @{ x = int, y = int }

fn print_pair(v : pair) : void =
  println!("@{ x = " + tostring_int(v.x) + ", y = " + tostring_int(v.y) + " }")

implement main0 () =
  {
    val pre_st = newm()
    val v = @{ x = 1, y = 2 }
    val () = print_pair(v)
    val st = pushm<pair>(pre_st, v)
    val- (_, ~Some_vt (z)) = popm(st)
  }
