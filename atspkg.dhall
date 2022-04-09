let prelude =
      https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall
        sha256:69bdde38a8cc01c91a1808ca3f45c29fe754c9ac96e91e6abd785508466399b4

in    prelude.default
    ⫽ { test =
        [   prelude.bin
          ⫽ { src = "test/stack.dats"
            , target = "${prelude.atsProject}/stack"
            , libs = [ "pthread", "atomic" ]
            }
        ]
      , compiler = [ 0, 4, 2 ]
      , version = [ 0, 4, 2 ]
      , cflags = [ "-O0", "-I", "." ]
      }
