let () =
  Alcotest.(
    run "Transpiler Test"
      [ T01_basic.cases; T02_sum.cases; T03_pair.cases; T04_lambda.cases ] )
