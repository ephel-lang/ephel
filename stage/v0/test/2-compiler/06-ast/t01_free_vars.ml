open Ephel.Compiler.Ast.Term
open Common

let cases =
  ( "Free variables"
  , [
      test "n => n" (Abs ([ "n" ], Var "n")) []
    ; test "n => v" (Abs ([ "n" ], Var "v")) [ "v" ]
    ; test "v 1" (App (Var "v", Int 1)) [ "v" ]
    ; test "()" Unit []
    ; test "1" (Int 1) []
    ; test "(1, n => n)" (Pair (Int 1, Abs ([ "n" ], Var "n"))) []
    ; test "(1, n => v)" (Pair (Int 1, Abs ([ "n" ], Var "v"))) [ "v" ]
    ; test "(n => n, 1)" (Pair (Abs ([ "n" ], Var "n"), Int 1)) []
    ; test "(n => v, 1)" (Pair (Abs ([ "n" ], Var "v"), Int 1)) [ "v" ]
    ; test "fst v" (Fst (Var "v")) [ "v" ]
    ; test "snd v" (Snd (Var "v")) [ "v" ]
    ; test "inl v" (Inl (Var "v")) [ "v" ]
    ; test "inr v" (Inr (Var "v")) [ "v" ]
    ; test "case v n t" (Case (Var "v", Var "n", Var "t")) [ "v"; "n"; "t" ]
    ] )
