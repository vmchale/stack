staload "SATS/stack.sats"
staload "libats/ML/SATS/string.sats"
staload EXTRA = "libats/ML/SATS/filebas.sats"

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
#include "share/HATS/atslib_staload_libats_libc.hats"
#include "DATS/stack.dats"

%{
#include <pthread.h>
%}

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

fn par_traverse(dir : string) : void =
  let
    // FIXME handle "." and ".." also do actual traversal?
    fn with_entry(st : &stack_t(string) >> stack_t(string), parent : string, str : string) : void =
      ifcase
        | str = "." => ()
        | str = ".." => ()
        | test_file_isdir(str) = 1 => push(st, parent + "/" + str)
        | _ => println!(parent + "/" + str)
    
    fun modify_stack(st : &stack_t(string) >> stack_t(string)) : void =
      let
        val opt_res = pop(st)
        val () = case+ opt_res of
          | ~Some_vt (str) => 
            begin
              let
                var files = $EXTRA.streamize_dirname_fname(str)
                
                fun stream_act(st : &stack_t(string) >> stack_t(string), x : stream_vt(string)) : void =
                  case+ !x of
                    | ~stream_vt_cons (x, xs) => (with_entry(st, str, x) ; stream_act(st, xs))
                    | ~stream_vt_nil() => ()
                
                val () = stream_act(st, files)
                val () = modify_stack(st)
              in end
            end
          | ~None_vt() => ()
      in end
    
    var stack: stack_t(string)
    val () = new(stack)
    val () = push(stack, ".")
    val () = modify_stack(stack)
    val () = free_stack(stack)
  in end

fun print_stream(x : stream_vt(string)) : void =
  case+ !x of
    | ~stream_vt_cons (y, ys) => (println!(y) ; print_stream(ys))
    | ~stream_vt_nil() => ()

implement main0 () =
  {
    // TODO: make this a directory traversal? print all files, push all directories
    fn push_pop(s : string, pre_st : stack_t(string)) : void =
      let
        val v = s
        val st = pushm<string>(pre_st, v)
        val (_, pulled) = popm(st)
        val () = case+ pulled of
          | ~Some_vt (z) => {
            var files = $EXTRA.streamize_dirname_fname(s)
            var ffiles = stream_vt_filter_cloptr(files, lam x => test_file_isdir(x) = 0)
            val () = print_stream(ffiles)
          }
          | ~None_vt() => ()
      in end
    
    fun loop_thread {i:nat} .<i>. (i : int(i), pre_st : stack_t(string)) : void =
      {
        var newthread: pthread_t
        var attr: pthread_attr_t
        val _ = pthread_attr_init(attr)
        val (pre_st0, pre_st1) = copy_stack(pre_st)
        val _ = pthread_create(newthread, attr, llam x => push_pop(".", x), pre_st0)
        var res: int
        val () = if i = 0 then
          { val- (_, ~None_vt()) = popm(pre_st1) }
        else
          loop_thread(i - 1, pre_st1)
        val _ = pthread_join(newthread, res)
      }
    
    val () = par_traverse(".")
  }
