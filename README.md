# stack

Implementation of a lock-free stack in ATS. It doesn't segfault when compiled
with `-O0` which doesn't exactly inspire confidence but it works.

I'd like to have a type-generic atomic pointer as well.
