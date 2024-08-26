let () =
  Alcotest.(
    run "Tokenizer Test"
      [
        T01_separators.cases
      ; T02_keywords.cases
      ; T03_literals.cases
      ; T04_identifiers.cases
      ; T05_spaces.cases
      ] )
