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
                              , (&env >> _) -> void
                              , (&env >> _)
                              ) : int =
  "mac#"

extern
fn pthread_attr_init(&pthread_attr_t? >> pthread_attr_t) : int =
  "mac#"

extern
fn pthread_join(pthread_t, &int? >> int) : int =
  "mac#"

fn traverse(dir : string) : void =
  {
    fn with_entry(st : &stack_t(string) >> stack_t(string), parent : string, str : string) :
      void =
      ifcase
        | str = "." => ()
        | str = ".." => ()
        | _ => push(st, parent + "/" + str)
    
    fun modify_stack(st : &stack_t(string) >> stack_t(string)) : void =
      let
        var pre_opt = pop(st)
      in
        case+ pre_opt of
          | ~Some_vt (str) => 
            begin
              if test_file_isdir(str) = 1 then
                let
                  var files = $EXTRA.streamize_dirname_fname(str)
                  
                  fun stream_act(st : &stack_t(string) >> stack_t(string), x : stream_vt(string)) : void =
                    case+ !x of
                      | ~stream_vt_cons (x, xs) => (with_entry(st, str, x) ; stream_act(st, xs))
                      | ~stream_vt_nil() => ()
                  
                  val () = stream_act(st, files)
                  val () = modify_stack(st)
                in end
              else
                (println!(str) ; modify_stack(st))
            end
          | ~None_vt() => ()
      end
    
    fun create_thread(st : &stack_t(string) >> _) : pthread_t =
      let
        var newthread: pthread_t
        var attr: pthread_attr_t
        var _ = pthread_attr_init(attr)
        var _ = pthread_create(newthread, attr, lam x => modify_stack(x), st)
      in
        newthread
      end
    
    fun loop { i : nat | i >= 1 } .<i>. (st : &stack_t(string) >> _, i : int(i)) :
      List0_vt(pthread_t) =
      if i = 1 then
        let
          var thread = create_thread(st)
        in
          list_vt_cons(thread, list_vt_nil())
        end
      else
        let
          var acc = loop(st, i - 1)
          var thread = create_thread(st)
        in
          list_vt_cons(thread, acc)
        end
    
    fun wait(threads : List0_vt(pthread_t)) : void =
      case+ threads of
        | ~list_vt_cons (x, xs) => 
          begin
            let
              var ret: int
              var _ = pthread_join(x, ret)
            in
              wait(xs)
            end
          end
        | ~list_vt_nil() => ()
    
    var stack: stack_t(string)
    val () = new(stack)
    val () = push(stack, dir)
    var threads = loop(stack, 1)
    val () = wait(threads)
    val () = release_stack(stack)
  }

implement main0 (argc, argv) =
  let
    var dir = if argc > 1 then
      argv[1]
    else
      "."
  in
    traverse(dir)
  end
