open Common

let cases =
  ("Identifier", [ test_expr "identifier" [ IDENT "identifier" ] (Ident ("identifier", region)) ])
