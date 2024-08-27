open Common

let cases =
  ( "Functional"
  , [
      test_expr "x => x" [ IDENT "x"; IMPLY; IDENT "x" ] (Abs ([ "x" ], Ident ("x", region), region))
    ; test_expr "f x => f"
        [ IDENT "f"; IDENT "x"; IMPLY; IDENT "f" ]
        (Abs ([ "f"; "x" ], Ident ("f", region), region))
    ; test_expr "f x" [ IDENT "f"; IDENT "x" ]
        (App (Ident ("f", region), Ident ("x", region), region))
    ; test_expr "f x y"
        [ IDENT "f"; IDENT "x"; IDENT "y" ]
        (App (App (Ident ("f", region), Ident ("x", region), region), Ident ("y", region), region))
    ; test_expr "x f => f x"
        [ IDENT "x"; IDENT "f"; IMPLY; IDENT "f"; IDENT "x" ]
        (Abs ([ "x"; "f" ], App (Ident ("f", region), Ident ("x", region), region), region))
    ; test_expr "let x = f in g"
        [ LET; IDENT "x"; EQUAL; IDENT "f"; IN; IDENT "g" ]
        (Let ("x", Ident ("f", region), Ident ("g", region), region))
    ; test_expr "let x = f y in g"
        [ LET; IDENT "x"; EQUAL; IDENT "f"; IDENT "y"; IN; IDENT "g" ]
        (Let
           ("x", App (Ident ("f", region), Ident ("y", region), region), Ident ("g", region), region)
        )
    ; test_expr "let x = f y in g x"
        [ LET; IDENT "x"; EQUAL; IDENT "f"; IDENT "y"; IN; IDENT "g"; IDENT "x" ]
        (Let
           ( "x"
           , App (Ident ("f", region), Ident ("y", region), region)
           , App (Ident ("g", region), Ident ("x", region), region)
           , region ) )
    ] )
