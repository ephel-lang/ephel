open Common

let cases =
  ( "Functional"
  , [
      test "x => x" [ IDENT "x"; IMPLY; IDENT "x" ] (Abs ([ "x" ], Ident ("x", region), region))
    ; test "f x => f"
        [ IDENT "f"; IDENT "x"; IMPLY; IDENT "f" ]
        (Abs ([ "f"; "x" ], Ident ("f", region), region))
    ; test "f x" [ IDENT "f"; IDENT "x" ] (App (Ident ("f", region), Ident ("x", region), region))
    ; test "f x y"
        [ IDENT "f"; IDENT "x"; IDENT "y" ]
        (App (App (Ident ("f", region), Ident ("x", region), region), Ident ("y", region), region))
    ; test "x f => f x"
        [ IDENT "x"; IDENT "f"; IMPLY; IDENT "f"; IDENT "x" ]
        (Abs ([ "x"; "f" ], App (Ident ("f", region), Ident ("x", region), region), region))
    ] )
