open Ephel.Compiler.Ast.Var

let test name input expected () = Alcotest.(check (list string)) name (free input) expected
let test name input expected = Alcotest.(test_case name `Quick (test name input expected))