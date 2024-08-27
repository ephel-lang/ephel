open Common

let cases =
  ( "Literals"
  , [
      test "123" [ INT 123 ] (Literal (Integer 123, region))
    ; test "\"a string\"" [ STRING "a string" ] (Literal (String "a string", region))
    ] )
