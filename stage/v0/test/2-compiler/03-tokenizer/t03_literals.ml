open Ephel.Compiler.Token
open Common

let cases =
  ( "Literals"
  , [
      test "123" "123" (Token.INT 123)
    ; test "\"a string\"" "\"a string\"" (Token.STRING "a string")
    ] )
