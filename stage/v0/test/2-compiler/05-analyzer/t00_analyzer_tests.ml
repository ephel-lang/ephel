let () =
  Alcotest.(
    run "Analyzer Test"
      [
        T01_identifier.cases
      ; T02_literal.cases
      ; T03_functional.cases
      ; T04_group.cases
      ; T05_product.cases
      ; T06_coproduct.cases
      ; T07_declaration.cases
      ] )
