open Common

let cases =
  ( "Coproducts"
  , [
      test "case identifier 21 32"
        [ CASE; IDENT "identifier"; INT 21; INT 32 ]
        (Case ("identifier", Literal (Integer 21, region), Literal (Integer 32, region), region))
    ; test "inl x" [ INL; IDENT "x" ] (Builtin (Inl, Ident ("x", region), region))
    ; test "inr x" [ INR; IDENT "x" ] (Builtin (Inr, Ident ("x", region), region))
    ] )