open Common

let cases =
  ( "Declarations"
  , [
      test_decl "val one = 1" [ VAL; IDENT "one"; EQUAL; INT 1 ] ("one", Literal (Integer 1, region))
    ; test_decl "val one = x => x"
        [ VAL; IDENT "one"; EQUAL; IDENT "x"; IMPLY; IDENT "x" ]
        ("one", Abs ([ "x" ], Ident ("x", region), region))
    ] )
