open Ephel.Compiler.Token
open Common

let cases =
  ( "Separators"
  , [
      test "lpar" "(" Token.LPAR
    ; test "rpar" ")" Token.RPAR
    ; test "equal" "=" Token.EQUAL
    ; test "imply" "=>" Token.IMPLY
    ; test "product" "," Token.PRODUCT
    ] )
