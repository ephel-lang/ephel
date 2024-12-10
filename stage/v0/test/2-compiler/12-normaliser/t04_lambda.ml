open Ephel.Compiler.Ast.Term
open Ephel.Compiler.Objcode.Objcode
open Ephel.Compiler.Objcode.Render
open Ephel.Compiler.Transpiler
open Ephel.Compiler.Expander
open Ephel.Compiler.Optimiser
open Ephel.Compiler.Simplifier
open Ephel.Compiler.Normaliser

open Preface.Result.Monad (struct
  type t = string
end)

let compile s =
  return s
  >>= Transpiler.run
  <&> Expander.run
  >>= Optimiser.run
  <&> Simplifier.run
  <&> Normaliser.run

let compile_01 () =
  let result = compile (Rec ("f", Abs ([ "x" ], App (Var "f", Var "x"))))
  and expected = [ LAMBDA_REC ("f", [ "x" ], [ EXEC ]) ] in
  Alcotest.(check (result string string))
    "compile rec(f).(fun x -> f x)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_02 () =
  let result =
    compile
      (Rec
         ( "f"
         , Abs
             ([ "x" ], Case (Var "x", Abs ([ "y" ], Var "y"), Abs ([ "y" ], App (Var "f", Var "y"))))
         ) )
  and expected =
    [
      LAMBDA_REC
        ( "f"
        , [ "x" ]
        , [ DUP (0, "x"); CASE ([ DROP (1, "x"); DROP (1, "f") ], [ DROP (1, "x"); EXEC ]) ] )
    ]
  in
  Alcotest.(check (result string string))
    "compile rec(f).(fun x -> case x (fun y -> y) (fun y -> f y))"
    (return expected <&> to_string)
    (result <&> to_string)

let cases =
  let open Alcotest in
  ( "Lambda Compilation"
  , [ test_case "compile O1" `Quick compile_01; test_case "compile O2" `Quick compile_02 ] )
