# stack

Bindings to [libatomic_ops](https://github.com/ivmai/libatomic_ops)' concurrent
stack.

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
