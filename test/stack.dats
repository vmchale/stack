staload "SATS/stack.sats"
staload "libats/ML/SATS/string.sats"

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
#include "DATS/stack.dats"

%{#
#include <pthread.h>
%}

vtypedef pair = @{ x = int, y = int }

fn print_pair(v : pair) : void =
  println!("@{ x = " + tostring_int(v.x) + ", y = " + tostring_int(v.y) + " }")

// int thrd_create( thrd_t *thr, thrd_start_t func, void *arg );
typedef pthread_t = $extype "pthread_t"
typedef pthread_attr_t = $extype "pthread_attr_t"

extern
fn pthread_create {env:vt@ype}( &pthread_t? >> pthread_t
                              , &pthread_attr_t
                              , env -<lin,1> void
                              , env
                              ) : int =
  "mac#"

extern
fn pthread_attr_init(&pthread_attr_t? >> pthread_attr_t) : int =
  "mac#"

extern
fn pthread_join(pthread_t, &int? >> int) : int =
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
    
    fun loop_thread {i:nat} .<i>. (i : int(i), pre_st : stack_t(pair)) : void =
      {
        var newthread: pthread_t
        var attr: pthread_attr_t
        val _ = pthread_attr_init(attr)
        val (pre_st0, pre_st1) = copy_stack(pre_st)
        val _ = pthread_create(newthread, attr, llam x => push_pop(0, x), pre_st0)
        var res: int
        val () = if i = 0 then
          { val- (_, ~None_vt()) = popm(pre_st1) }
        else
          loop_thread(i - 1, pre_st1)
        val _ = pthread_join(newthread, res)
      }
    
    val () = loop_thread(10, pre_st)
  }
