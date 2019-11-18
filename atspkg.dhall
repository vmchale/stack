let prelude = https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall

in prelude.default ⫽
  { test =
    [ prelude.bin ⫽
      { src = "test/stack.dats"
      , target = "${prelude.atsProject}/stack"
      , libs = [ "pthread", "atomic" ]
      , gcBin = True
      }
    ]
  , cflags = [ "-O2", "-I", "." ]
  }
