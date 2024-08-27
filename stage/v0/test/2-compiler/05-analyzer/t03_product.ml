open Common

let cases =
  ( "Products"
  , [
      test "42,24" [ INT 42; PRODUCT; INT 24 ]
        (Pair (Literal (Integer 42, region), Literal (Integer 24, region), region))
    ; test "fst" [ FST ] (Builtin (Fst, region))
    ; test "snd" [ SND ] (Builtin (Snd, region))
    ] )
