open Common

let cases =
  ("Identifier", [ test "identifier" [ IDENT "identifier" ] (Ident ("identifier", region)) ])
