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

fn par_traversem(dir : string) : void =
  let
    fn with_entrym(st : stack_t(string), parent : string, str : string) : stack_t(string) =
      ifcase
        | str = "." => st
        | str = ".." => st
        | _ => pushm(st, parent + "/" + str)
    
    fun modify_stackm(st : stack_t(string)) : stack_t(string) =
      let
        val (new_st, opt_res) = popm(st)
      in
        case+ opt_res of
          | ~Some_vt (str) => 
            begin
              if test_file_isdir(str) = 1 then
                let
                  var files = $EXTRA.streamize_dirname_fname(str)
                  
                  fun stream_act(st : stack_t(string), x : stream_vt(string)) : stack_t(string) =
                    case+ !x of
                      | ~stream_vt_cons (y, ys) => 
                        begin
                          let
                            val new_st = with_entrym(st, str, y)
                          in
                            stream_act(new_st, ys)
                          end
                        end
                      | ~stream_vt_nil() => st
                  
                  val act_st = stream_act(new_st, files)
                in
                  modify_stackm(act_st)
                end
              else
                (println!(str) ; modify_stackm(new_st))
            end
          | ~None_vt() => new_st
      end
    
    val pre_stack = newm()
    val stack = pushm(pre_stack, dir)
    
    fun create_thread(st : stack_t(string)) : pthread_t =
      let
        var newthread: pthread_t
        var attr: pthread_attr_t
        val _ = pthread_attr_init(attr)
        val _ = pthread_create(newthread, attr, llam x => let
                                val final_st = modify_stackm(x)
                              in
                                release_stack(final_st)
                              end, st)
      in
        newthread
      end
    
    fun loop_threads {i:nat} .<i>. (st : stack_t(string), i : int(i)) : void =
      if i = 0 then
        let
          var newthread = create_thread(st)
          var res: int
          val _ = pthread_join(newthread, res)
        in end
      else
        let
          val (st0, st1) = copy_stack(st)
          val _ = create_thread(st0)
        in
          loop_threads(st1, i - 1)
        end
  in
    loop_threads(stack, 5)
  end

fn traverse(dir : string) : void =
  {
    fn with_entry(st : &stack_t(string) >> stack_t(string), parent : string, str : string) :
      void =
      ifcase
        | str = "." => ()
        | str = ".." => ()
        | test_file_isdir(parent + "/" + str) = 1 => push(st, parent + "/" + str)
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
    val () = release_stack(stack)
  }

implement main0 (argc, argv) =
  let
    val dir = if argc > 1 then
      argv[1]
    else
      "."
  in
    par_traversem(dir)
  end
