open Ephel.Compiler.Ast.Term
open Ephel.Compiler.Objcode.Objcode
open Ephel.Compiler.Objcode.Render
open Ephel.Compiler.Transpiler

open Preface.Result.Monad (struct
  type t = string
end)

let compile s = return s >>= Transpiler.run

let compile_01 () =
  let result = compile (Inl (Int 1))
  and expected = [ PUSH (INT 1); LEFT ] in
  Alcotest.(check (result string string))
    "compile Inl 1"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_02 () =
  let result = compile (Inr (Int 1))
  and expected = [ PUSH (INT 1); RIGHT ] in
  Alcotest.(check (result string string))
    "compile Inr 1"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_03 () =
  let result = compile (Case (Inl (Int 1), Abs ("x", Var "x"), Abs ("x", Var "x")))
  and expected =
    [ PUSH (INT 1); LEFT; CASE ([ DUP (0, "x"); DROP (1, "x") ], [ DUP (0, "x"); DROP (1, "x") ]) ]
  in
  Alcotest.(check (result string string))
    "compile case (inl 1) (fun x -> x) (fun x -> x)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_04 () =
  let result = compile (Case (Inr (Int 1), Abs ("x", Var "x"), Abs ("x", Var "x")))
  and expected =
    [ PUSH (INT 1); RIGHT; CASE ([ DUP (0, "x"); DROP (1, "x") ], [ DUP (0, "x"); DROP (1, "x") ]) ]
  in
  Alcotest.(check (result string string))
    "compile case (inr 1) (fun x -> x) (fun x -> x)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_05 () =
  let result = compile (Case (Inl (Int 1), Abs ("x", Int 2), Abs ("x", Var "x")))
  and expected =
    [ PUSH (INT 1); LEFT; CASE ([ PUSH (INT 2); DROP (1, "x") ], [ DUP (0, "x"); DROP (1, "x") ]) ]
  in
  Alcotest.(check (result string string))
    "compile case (inl 1) (fun x -> 2) (fun x -> x)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_06 () =
  let result = compile (Case (Inr (Int 1), Abs ("x", Var "x"), Abs ("x", Int 2)))
  and expected =
    [ PUSH (INT 1); RIGHT; CASE ([ DUP (0, "x"); DROP (1, "x") ], [ PUSH (INT 2); DROP (1, "x") ]) ]
  in
  Alcotest.(check (result string string))
    "compile case (inr 1) (fun x -> x) (fun x -> 2)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_07 () =
  let result =
    compile
      (Case
         ( Inl (Inr (Int 1))
         , Abs ("x", Case (Var "x", Abs ("y", Var "y"), Abs ("y", Int 2)))
         , Abs ("x", Int 3) ) )
  and expected =
    [
      PUSH (INT 1)
    ; RIGHT
    ; LEFT
    ; CASE
        ( [
            DUP (0, "x")
          ; CASE ([ DUP (0, "y"); DROP (1, "y") ], [ PUSH (INT 2); DROP (1, "y") ])
          ; DROP (1, "x")
          ]
        , [ PUSH (INT 3); DROP (1, "x") ] )
    ]
  in
  Alcotest.(check (result string string))
    "compile case (inl inr 1) (fun x -> case x (fun y -> y) (fun y -> 2)) (fun x -> 3)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_08 () =
  let result = compile (Case (Inl (Int 1), Abs ("x", Unit), Abs ("x", Var "x")))
  and expected =
    [ PUSH (INT 1); LEFT; CASE ([ PUSH UNIT; DROP (1, "x") ], [ DUP (0, "x"); DROP (1, "x") ]) ]
  in
  Alcotest.(check (result string string))
    "compile case (inl 1) (fun x -> unit) (fun x -> x)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_09 () =
  let result = compile (Abs ("y", Case (Var "y", Abs ("x", Unit), Abs ("x", Var "y"))))
  and expected =
    [
      LAMBDA
        ( "y"
        , [
            DUP (0, "y")
          ; CASE ([ PUSH UNIT; DROP (1, "x") ], [ DUP (1, "y"); DROP (1, "x") ])
          ; DROP (1, "y")
          ] )
    ]
  in
  Alcotest.(check (result string string))
    "compile fun y -> case y (fun x -> unit) (fun x -> y)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_10 () =
  let result = compile (Abs ("y", Case (Var "y", Abs ("x", Unit), Abs ("x", Var "x"))))
  and expected =
    [
      LAMBDA
        ( "y"
        , [
            DUP (0, "y")
          ; CASE ([ PUSH UNIT; DROP (1, "x") ], [ DUP (0, "x"); DROP (1, "x") ])
          ; DROP (1, "y")
          ] )
    ]
  in
  Alcotest.(check (result string string))
    "compile fun y -> case y (fun x -> unit) (fun x -> x)"
    (return expected <&> to_string)
    (result <&> to_string)

let compile_11 () =
  let result = compile (Abs ("x", Case (Inl (Var "x"), Abs ("x", Var "x"), Abs ("x", Int 3))))
  and expected =
    [
      LAMBDA
        ( "x"
        , [
            DUP (0, "x")
          ; LEFT
          ; CASE ([ DUP (0, "x"); DROP (1, "x") ], [ PUSH (INT 3); DROP (1, "x") ])
          ; DROP (1, "x")
          ] )
    ]
  in
  Alcotest.(check (result string string))
    "compile (fun x -> case (inl x) (fun x -> x) (fun _ -> 2))"
    (return expected <&> to_string)
    (result <&> to_string)

let cases =
  let open Alcotest in
  ( "Sum Compilation"
  , [
      test_case "compile O1" `Quick compile_01
    ; test_case "compile O2" `Quick compile_02
    ; test_case "compile O3" `Quick compile_03
    ; test_case "compile O4" `Quick compile_04
    ; test_case "compile O5" `Quick compile_05
    ; test_case "compile O6" `Quick compile_06
    ; test_case "compile O7" `Quick compile_07
    ; test_case "compile O8" `Quick compile_08
    ; test_case "compile O9" `Quick compile_09
    ; test_case "compile 10" `Quick compile_10
    ; test_case "compile 11" `Quick compile_11
    ] )
