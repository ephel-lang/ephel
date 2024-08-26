open Ephel.Parser.Parsec
open Ephel.Parser.Source
open Ephel.Compiler.Token
open Ephel.Compiler.Tokenizer
open Preface.Option.Monad

let response r =
  let open Response.Destruct in
  fold
    ~success:(fun ((a, _), _, _) -> Some a)
    ~failure:(fun (_, _, _) -> None)
    r

let test name input expected () =
  let module Parsec = Parsec (FromChars) in
  let open Eval (Parsec) in
  let result =
    Tokenizer.tokenize (module Parsec)
    @@ Parsec.source (Utils.chars_of_string input)
  and expected = Some expected in
  Alcotest.(check (option string))
    name
    (expected <&> Render.to_string)
    (response result <&> Render.to_string)

let test name input expected =
  Alcotest.(test_case name `Quick (test name input expected))
