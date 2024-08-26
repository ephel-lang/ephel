open Ephel.Compiler.Token
open Ephel.Compiler.Cst
open Common

let cases =
  ( "Literals"
  , [
      test "123" [ Token.INT 123 ] (Cst.Literal (Integer 123, region))
    ; test "\"a string\""
        [ Token.STRING "a string" ]
        (Cst.Literal (String "a string", region))
    ] )
