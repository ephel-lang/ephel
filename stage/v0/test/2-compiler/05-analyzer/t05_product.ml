open Common

let cases =
  ( "Products"
  , [
      test "42,24" [ INT 42; PRODUCT; INT 24 ]
        (Pair (Literal (Integer 42, region), Literal (Integer 24, region), region))
    ; test "x => y,24"
        [ IDENT "x"; IMPLY; IDENT "y"; PRODUCT; INT 24 ]
        (Abs ([ "x" ], Pair (Ident ("y", region), Literal (Integer 24, region), region), region))
    ; test "(x => y),24"
        [ LPAR; IDENT "x"; IMPLY; IDENT "y"; RPAR; PRODUCT; INT 24 ]
        (Pair (Abs ([ "x" ], Ident ("y", region), region), Literal (Integer 24, region), region))
    ; test "fst x" [ FST; IDENT "x" ] (Builtin (Fst, Ident ("x", region), region))
    ; test "snd x" [ SND; IDENT "x" ] (Builtin (Snd, Ident ("x", region), region))
    ] )
