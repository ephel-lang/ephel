let () =
  Alcotest.(
    run "Analyzer Test"
      [
        T01_identifier.cases
      ; T02_literal.cases
      ; T03_product.cases
      ; T04_coproduct.cases
      ; T05_functional.cases
      ] )
