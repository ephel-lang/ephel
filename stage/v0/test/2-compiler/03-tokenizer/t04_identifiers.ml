open Ephel.Compiler.Token
open Common

let cases =
  ( "Identifiers"
  , [
      test "identifier" "identifier" (Token.IDENT "identifier")
    ; test "is-empty?" "is-empty?" (Token.IDENT "is-empty?")
    ] )
