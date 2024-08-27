open Ephel.Parser.Parsec
open Common

let to_result = function
  | Some (Either.Left a) -> Some (Result.Ok a)
  | Some (Either.Right a) -> Some (Result.Error a)
  | None -> None

let parser_seq () =
  let open Control.Monad (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ (return 'a' <+> return 1) @@ Parsec.source []
  and expected = (Some ('a', 1), false) in
  Alcotest.(check (pair (option (pair char int)) bool)) "sequence" expected result

let parser_seq_left () =
  let open Control.Monad (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ (return 'a' <+< return 1) @@ Parsec.source []
  and expected = (Some 'a', false) in
  Alcotest.(check (pair (option char) bool)) "sequence left" expected result

let parser_seq_right () =
  let open Control.Monad (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ (return 'a' >+> return 1) @@ Parsec.source []
  and expected = (Some 1, false) in
  Alcotest.(check (pair (option int) bool)) "sequence right" expected result

let parser_choice_left () =
  let open Control.Monad (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ (return 'a' <|> return 'b') @@ Parsec.source []
  and expected = (Some 'a', false) in
  Alcotest.(check (pair (option char) bool)) "choice left" expected result

let parser_choice_right () =
  let open Control.Monad (Parsec) in
  let open Eval (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ (fail <|> return 'b') @@ Parsec.source []
  and expected = (Some 'b', false) in
  Alcotest.(check (pair (option char) bool)) "choice right" expected result

let parser_choice_fail () =
  let open Control.Monad (Parsec) in
  let open Eval (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ (fail ~consumed:true <|> return 'b') @@ Parsec.source []
  and expected = (None, true) in
  Alcotest.(check (pair (option char) bool)) "choice fail" expected result

let parser_backtrack_choice_left () =
  let open Control.Monad (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ ?=(return 'a' <||> return 'b') @@ Parsec.source []
  and expected = (Some 'a', false) in
  Alcotest.(check (pair (option char) bool)) "backtrack choice left" expected result

let parser_backtrack_choice_right () =
  let open Control.Monad (Parsec) in
  let open Eval (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ ?=(fail <||> return 'b') @@ Parsec.source []
  and expected = (Some 'b', false) in
  Alcotest.(check (pair (option char) bool)) "backtrack choice right" expected result

let parser_backtrack_choice_do_not_fail () =
  let open Control.Monad (Parsec) in
  let open Eval (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ ?=(?!(fail ~consumed:true) <||> return 'b') @@ Parsec.source []
  and expected = (Some 'b', false) in
  Alcotest.(check (pair (option char) bool)) "backtrack choice do not fail" expected result

let parser_either_choice_left () =
  let open Control.Monad (Parsec) in
  let open Eval (Parsec) in
  let open Operator (Parsec) in
  let result, consume = response @@ (return 'b' <||> return 1) @@ Parsec.source []
  and expected = (Some (Result.Ok 'b'), false) in
  Alcotest.(check (pair (option (result char int)) bool))
    "either choice left" expected
    (to_result result, consume)

let parser_either_choice_right () =
  let open Control.Monad (Parsec) in
  let open Eval (Parsec) in
  let open Operator (Parsec) in
  let result, consume = response @@ (fail <||> return 1) @@ Parsec.source []
  and expected = (Some (Result.Error 1), false) in
  Alcotest.(check (pair (option (result char int)) bool))
    "either choice left" expected
    (to_result result, consume)

let parser_satisfy () =
  let open Control.Monad (Parsec) in
  let open Eval (Parsec) in
  let open Operator (Parsec) in
  let result = response @@ (return 1 <?> ( = ) 1) @@ Parsec.source []
  and expected = (Some 1, false) in
  Alcotest.(check (pair (option int) bool)) "satisfy" expected result

let cases =
  let open Alcotest in
  ( "Operator Parser"
  , [
      test_case "sequence" `Quick parser_seq
    ; test_case "sequence left" `Quick parser_seq_left
    ; test_case "sequence right" `Quick parser_seq_right
    ; test_case "choice left" `Quick parser_choice_left
    ; test_case "choice right" `Quick parser_choice_right
    ; test_case "choice fail" `Quick parser_choice_fail
    ; test_case "backtrack choice left" `Quick parser_backtrack_choice_left
    ; test_case "backtrack choice right" `Quick parser_backtrack_choice_right
    ; test_case "backtrack choice do not fail" `Quick parser_backtrack_choice_do_not_fail
    ; test_case "either choice left" `Quick parser_either_choice_left
    ; test_case "either choice right" `Quick parser_either_choice_right
    ; test_case "satisfy" `Quick parser_satisfy
    ] )
