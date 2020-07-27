let prelude =
      https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall sha256:c04fe26a86f2e2bd5c67c17f213ee30379d520f5fad11254a8f17e936250e27e

in    prelude.default
    ⫽ { test =
        [   prelude.bin
          ⫽ { src = "test/stack.dats"
            , target = "${prelude.atsProject}/stack"
            , libs = [ "pthread", "atomic_ops_gpl", "atomic_ops" ]
            }
        ]
      , cflags = [ "-O2", "-I", "." ]
      }
