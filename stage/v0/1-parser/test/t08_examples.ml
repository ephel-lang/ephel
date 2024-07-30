open Common

let parse_expr () =
  let open Ephel_parsec_parser.Parser.Core (Parsec) in
  let open Ephel_parsec_parser.Parser.Literal (Parsec) in
  let open Ephel_parsec_source.Source.Utils in
  (*
    expr ::= natural ((+|-) expr)? | "(" expr ")"
  *)
  let _OPERATOR_ = char_in_string "+-"
  and _LPAR_ = char '('
  and _RPAR_ = char ')' in
  let operations expr = integer <+> opt (_OPERATOR_ <+> expr) >+> return ()
  and parenthesis expr = _LPAR_ <+> expr <+> _RPAR_ >+> return () in
  let expr = fix (fun expr -> operations expr <|> parenthesis expr) in
  let result = response @@ expr @@ Parsec.source (chars_of_string "+1+(-2+-3)")
  and expected = (Some (), true) in
  Alcotest.(check (pair (option unit) bool)) "parse expression" expected result

let cases =
  let open Alcotest in
  ("Examples Parser", [ test_case "expression parser" `Quick parse_expr ])
