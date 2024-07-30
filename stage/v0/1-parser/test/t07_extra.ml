open Ephel_parsec_parser.Parser
open Common

let parser_eager_choice_left () =
  let open Control.Monad (Parsec) in
  let open Operator (Parsec) in
  let open Literal (Parsec) in
  let result =
    response
    @@ ?=( char 'a'
         <+> char 'b'
         <&> (fun _ -> 1)
         <|||> (char 'a' <+> char 'b' <&> fun _ -> 2) )
    @@ Parsec.source [ 'a'; 'b' ]
  and expected = (Some 1, true) in
  Alcotest.(check (pair (option int) bool)) "eager choice left" expected result

let parser_eager_choice_right () =
  let open Control.Monad (Parsec) in
  let open Operator (Parsec) in
  let open Literal (Parsec) in
  let result =
    response
    @@ ?=(char 'a' <&> (fun _ -> 1) <|||> (char 'a' <+> char 'b' <&> fun _ -> 2))
    @@ Parsec.source [ 'a'; 'b' ]
  and expected = (Some 2, true) in
  Alcotest.(check (pair (option int) bool)) "eager choice right" expected result

let cases =
  let open Alcotest in
  ( "Extra Parser"
  , [
      test_case "eager choice left" `Quick parser_eager_choice_left
    ; test_case "eager choice right" `Quick parser_eager_choice_right
    ] )
