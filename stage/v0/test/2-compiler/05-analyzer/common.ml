open Ephel.Parser.Parsec
open Ephel.Parser.Source
open Ephel.Compiler.Token
open Ephel.Compiler.Cst
open Ephel.Compiler.Analyzer
open Preface.Option.Monad

let location = Location.Construct.create ~file:None ~position:0 ~line:0 ~column:0
let region = Region.Construct.create ~first:location ~last:location

module FromTokensWithRegion = FromList (struct
  type e = Token.with_region

  let locate l = function _ -> l
end)

let response r =
  let open Response.Destruct in
  fold ~success:(fun (a, _, _) -> Some a) ~failure:(fun (_, _, _) -> None) r

let test_expr name input expected () =
  let module Parsec = Parsec (FromTokensWithRegion) in
  let module Core = Core (Parsec) in
  let result =
    Core.(Analyser.term (module Parsec) <+< eos)
    @@ Parsec.source
    @@ List.map (fun e -> (e, region)) input
  and expected = Some expected in
  Alcotest.(check (option string))
    name (expected <&> Render.to_string)
    (response result <&> Render.to_string)

let test_decl name input expected () =
  let module Parsec = Parsec (FromTokensWithRegion) in
  let module Core = Core (Parsec) in
  let result =
    Core.(Analyser.declaration (module Parsec) <+< eos)
    @@ Parsec.source
    @@ List.map (fun e -> (e, region)) input
  and expected = Some expected in
  Alcotest.(check (option string))
    name
    (expected <&> fun (n, t) -> n ^ ":" ^ Render.to_string t)
    (response result <&> fun (n, t) -> n ^ ":" ^ Render.to_string t)

let test_expr name input expected = Alcotest.(test_case name `Quick (test_expr name input expected))
let test_decl name input expected = Alcotest.(test_case name `Quick (test_decl name input expected))
