open Ephel.Compiler.Ast.Term
open Ephel.Compiler.Objcode.Objcode
open Ephel.Compiler.Objcode.Render
open Ephel.Compiler.Transpiler
open Ephel.Compiler.Expander

open Preface.Result.Monad (struct
  type t = string
end)

let compile s = return s >>= Transpiler.run <&> Expander.run

let compile_01 () =
  let result = compile (Int 1)
  and expected = [ PUSH (INT 1) ] in
  Alcotest.(check (result string string))
    "compile 1"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_02 () =
  let result = compile (Abs ("x", Var "x"))
  and expected = [ LAMBDA ("x", [ DUP (0, "x"); DROP (1, "x") ]) ] in
  Alcotest.(check (result string string))
    "compile fun x -> x"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_03 () =
  let result = compile (Abs ("x", Unit))
  and expected = [ LAMBDA ("x", [ PUSH UNIT; DROP (1, "x") ]) ] in
  Alcotest.(check (result string string))
    "compile fun x -> unit"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_04 () =
  let result = compile (App (Abs ("x", Var "x"), Int 1))
  and expected = [ LAMBDA ("x", [ DUP (0, "x"); DROP (1, "x") ]); PUSH (INT 1); EXEC ] in
  Alcotest.(check (result string string))
    "compile (fun x -> x) 1"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_05 () =
  let result = compile (App (Abs ("x", Unit), Int 1))
  and expected = [ LAMBDA ("x", [ PUSH UNIT; DROP (1, "x") ]); PUSH (INT 1); EXEC ] in
  Alcotest.(check (result string string))
    "compile (fun x -> unit) 1"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_06 () =
  let result = compile (App (App (Abs ("x", Abs ("y", Var "y")), Int 1), Int 2))
  and expected =
    [
      LAMBDA ("x", [ LAMBDA ("y", [ DUP (0, "y"); DROP (1, "y") ]); DROP (1, "x") ])
    ; PUSH (INT 1)
    ; EXEC
    ; PUSH (INT 2)
    ; EXEC
    ]
  in
  Alcotest.(check (result string string))
    "compile (fun x y -> y) 1 2"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_07 () =
  (* PARTIAL APPLICATION *)
  let result = compile (App (App (Abs ("x", Abs ("y", Var "x")), Int 1), Int 2))
  and expected = [ PUSH (INT 1) ] in
  Alcotest.(check (result string string))
    "compile (fun x y -> x) 1 2"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_08 () =
  let result = compile (Let ("x", Int 1, Var "x"))
  and expected = [ PUSH (INT 1); DUP (0, "x"); DROP (1, "x") ] in
  Alcotest.(check (result string string))
    "compile let x = 1 in x"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_09 () =
  (* PARTIAL APPLICATION *)
  let result = compile (Abs ("f", Abs ("x", App (Var "f", Var "x"))))
  and expected = [ LAMBDA ("f", [ LAMBDA ("x", [ DIG (1, "f"); EXEC ]) ]) ] in
  Alcotest.(check (result string string))
    "compile (fun f x -> f x)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_10 () =
  let result = compile (Abs ("f", Let ("x", Int 1, App (Var "f", Var "x"))))
  and expected =
    [
      LAMBDA ("f", [ PUSH (INT 1); DUP (1, "f"); DUP (1, "x"); EXEC; DROP (1, "x"); DROP (1, "f") ])
    ]
  in
  Alcotest.(check (result string string))
    "compile (fun f -> let x = 1 in f x)"
    (return expected <&> to_string)
    (result <&> to_string)

let cases =
  let open Alcotest in
  ( "Basic Compilation"
  , [
      test_case "compile O1" `Quick compile_01
    ; test_case "compile O2" `Quick compile_02
    ; test_case "compile O3" `Quick compile_03
    ; test_case "compile O4" `Quick compile_04
    ; test_case "compile O5" `Quick compile_05
    ; test_case "compile O6" `Quick compile_06 (*; test_case "compile O7" `Quick compile_07*)
    ; test_case "compile O8" `Quick compile_08 (*; test_case "compile O9" `Quick compile_09*)
    ; test_case "compile 10" `Quick compile_10
    ] )
