# stack

Implementation of a lock-free stack in ATS. Currently I don't really know if
this works.

I'd like to have a type-generic atomic pointer as well, but that seems
infeasible at the moment.

## Building

I use [`atspkg`](http://hackage.haskell.org/package/ats-pkg) to build/hack on
this; you can install it with

```
curl -sSl https://raw.githubusercontent.com/vmchale/atspkg/master/bash/install.sh | sh -s
```

And then run the test suite with

```
atspkg test
```

## Contents

```
-------------------------------------------------------------------------------
 Language             Files       Lines         Code     Comments       Blanks
-------------------------------------------------------------------------------
 ATS                      3         201          163            4           34
 Dhall                    2          16           14            0            2
 Justfile                 1           3            3            0            0
 Markdown                 2          23           20            0            3
 TOML                     1           3            3            0            0
 YAML                     1          13           13            0            0
-------------------------------------------------------------------------------
 Total                   10         259          216            4           39
-------------------------------------------------------------------------------
```
