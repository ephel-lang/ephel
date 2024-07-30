open Ephel_parsec_parser.Parser
open Common

let parser_seq () =
  let open Syntax (Parsec) in
  let open Control.Monad (Parsec) in
  let p =
    let+ a = return 'a'
    and<+> b = return 1 in
    (a, b)
  in
  let result = response @@ p @@ Parsec.source []
  and expected = (Some ('a', 1), false) in
  Alcotest.(check (pair (option (pair char int)) bool))
    "sequence" expected result

let parser_seq_left () =
  let open Syntax (Parsec) in
  let open Control.Monad (Parsec) in
  let p =
    let+ a = return 'a'
    and<+> _ = return 1 in
    a
  in
  let result = response @@ p @@ Parsec.source []
  and expected = (Some 'a', false) in
  Alcotest.(check (pair (option char) bool)) "sequence left" expected result

let parser_seq_right () =
  let open Syntax (Parsec) in
  let open Control.Monad (Parsec) in
  let p =
    let+ _ = return 'a'
    and<+> b = return 1 in
    b
  in
  let result = response @@ p @@ Parsec.source []
  and expected = (Some 1, false) in
  Alcotest.(check (pair (option int) bool)) "sequence right" expected result

let cases =
  let open Alcotest in
  ( "Syntax Parser"
  , [
      test_case "sequence" `Quick parser_seq
    ; test_case "sequence left" `Quick parser_seq_left
    ; test_case "sequence right" `Quick parser_seq_right
    ] )
