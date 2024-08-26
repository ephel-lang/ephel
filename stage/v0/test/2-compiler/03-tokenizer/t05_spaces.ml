open Ephel.Compiler.Token
open Common

let cases =
  ( "Identifiers with Spaces"
  , [
      test "identifier" "  identifier  " (Token.IDENT "identifier")
    ; test "is-empty?" "    is-empty?  " (Token.IDENT "is-empty?")
    ] )
