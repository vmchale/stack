#include "share/atspre_staload.hats"

%{
#include <pthread.h>
#include <stdatomic.h>
%}

datatype stack_t(a: t@ype+) =
  | cons of (a, stack_t(a))
  | nil

extern
fn atomic_compare_exchange {a:t@ype}(&a >> _, a, a) : bool =
  "mac#atomic_compare_exchange_strong"

fn new {a:t@ype}(st : &stack_t(a)? >> stack_t(a)) : void =
  st := nil

fun push {a:t@ype}(st : &stack_t(a) >> stack_t(a), x : a) : void =
  let
    var xs0 = st
    var xs1 = cons(x, xs0)
  in
    if atomic_compare_exchange(st, xs0, xs1) then
      ()
    else
      push(st, x)
  end

fun pop {a:t@ype}(st : &stack_t(a) >> stack_t(a)) : Option(a) =
  let
    var xs0 = st
  in
    case+ xs0 of
      | nil() => None
      | cons (x, xs1) => if atomic_compare_exchange(st, xs0, xs1) then
        Some(x)
      else
        pop(st)
  end

implement main0 (argc, argv) =
  let
    var st: stack_t(string)
    val () = new(st)
    val () = push(st, "Hello, world!")
    val- Some (x) = pop(st)
    val () = print_string(x)
  in end
