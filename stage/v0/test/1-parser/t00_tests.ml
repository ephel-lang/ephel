let () =
  Alcotest.(
    run "Parser Test"
      [
        T01_eval.cases
      ; T02_operator.cases
      ; T03_atomic.cases
      ; T04_occurrence.cases
      ; T05_literal.cases
      ; T06_syntax.cases
      ; T07_extra.cases
      ; T08_examples.cases
      ; T99_laws.cases
      ] )
