open Ephel.Compiler.Tokenizer
open Common

let cases =
  ( "Keywords"
  , [
      test "inl" "inl" Token.INL
    ; test "inr" "inr" Token.INR
    ; test "case" "case" Token.CASE
    ; test "let" "let" Token.LET
    ; test "in" "in" Token.IN
    ; test "fst" "fst" Token.FST
    ; test "snd" "snd" Token.SND
    ; test "val" "val" Token.VAL
    ] )
