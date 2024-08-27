open Common

let cases =
  ( "Groups"
  , [
      test_expr "()" [ LPAR; RPAR ] (Unit region)
    ; test_expr "(123)" [ LPAR; INT 123; RPAR ] (Literal (Integer 123, region))
    ; test_expr "x (y z)"
        [ IDENT "x"; LPAR; IDENT "y"; IDENT "z"; RPAR ]
        (App (Ident ("x", region), App (Ident ("y", region), Ident ("z", region), region), region))
    ; test_expr "(x => y) z"
        [ LPAR; IDENT "x"; IMPLY; IDENT "y"; RPAR; IDENT "z" ]
        (App (Abs ([ "x" ], Ident ("y", region), region), Ident ("z", region), region))
    ] )
