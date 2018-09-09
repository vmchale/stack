staload "SATS/stack.sats"
staload "libats/ML/SATS/string.sats"

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
#include "DATS/stack.dats"

%{#
#include <pthread.h>
%}

typedef pair = @{ x = int, y = int }

fn print_pair(v : pair) : void =
  println!("@{ x = " + tostring_int(v.x) + ", y = " + tostring_int(v.y) + " }")

// int thrd_create( thrd_t *thr, thrd_start_t func, void *arg );
typedef pthread = $extype "pthread_t"
typedef pthread_attr = $extype "pthread_attr_t"

extern
fn pthread_create {env:vt@ype}(&pthread? >> pthread, &pthread_attr, env -> void, env) : int =
  "mac#"

extern
fn pthread_attr_init(&pthread_attr? >> pthread_attr) : int =
  "mac#"

extern
fn pthread_join(pthread, &int? >> int) : int =
  "mac#"

implement main0 () =
  {
    val pre_st = newm()
    
    fn push_pop(i : int, pre_st : stack_t(pair)) : void =
      let
        val v = @{ x = i, y = i }
        val st = pushm<pair>(pre_st, v)
        val- (_, ~Some_vt (z)) = popm(st)
        val () = print_pair(z)
      in end
    
    val () = push_pop(0, pre_st)
    
    fun loop_thread {i:nat} .<i>. (i : int(i)) : void =
      {
        var newthread: pthread
        var attr: pthread_attr
        val _ = pthread_attr_init(attr)
        val j = i
        val _ = pthread_create{int}(newthread, attr, lam x => println!(x), j)
        var res: int
        val () = if i = 0 then
          ()
        else
          loop_thread(i - 1)
        val _ = pthread_join(newthread, res)
      }
    
    val () = loop_thread(10)
  }
