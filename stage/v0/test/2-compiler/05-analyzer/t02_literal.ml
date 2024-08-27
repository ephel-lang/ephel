open Common

let cases =
  ( "Literals"
  , [
      test_expr "123" [ INT 123 ] (Literal (Integer 123, region))
    ; test_expr "\"a string\"" [ STRING "a string" ] (Literal (String "a string", region))
    ] )
