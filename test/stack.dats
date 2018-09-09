staload "SATS/stack.sats"
staload "libats/ML/SATS/string.sats"

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
#include "DATS/stack.dats"

%{#
#include <threads.h>
%}

typedef pair = @{ x = int, y = int }

fn print_pair(v : pair) : void =
  println!("@{ x = " + tostring_int(v.x) + ", y = " + tostring_int(v.y) + " }")

// int thrd_create( thrd_t *thr, thrd_start_t func, void *arg );
typedef thrd_t = $extype "thrd_t"

extern
fn thrd_create {env:vt@ype} (&thrd_t? >> thrd_t, env -> void, env) : int

extern
fn thrd_join(thrd_t, &int? >> int) : int

implement main0 () =
  {
    val pre_st = newm()
    val v = @{ x = 1, y = 2 }
    var newthread: thrd_t
    val _ = thrd_create{string}(newthread, lam x => println!(x), "Hello, World!")
    var res: int
    val _ = thrd_join(newthread, res)
    val st = pushm<pair>(pre_st, v)
    val- (_, ~Some_vt (z)) = popm(st)
    val () = print_pair(z)
  }
