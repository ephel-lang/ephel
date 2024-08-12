(* Rules *)

open Ephel_parser_source
open Ephel_parser_parsec
open Ephel_compiler_tokenizer

module Rules (Parsec : Specs.PARSEC with type Source.e = Token.with_location) =
struct
  open Ephel_parser_parsec.Core (Parsec)
  open Preface_core.Fun

  (* Basic matchers *)

  let is_identifier = function
    | Token.IDENT s, r -> return (s, r)
    | _ -> fail ?consumed:None ?message:None

  let is_string_or_int = function
    | Token.STRING s, r -> return (Cst.Literal (Cst.String s), r)
    | Token.INTEGER s, r -> return (Cst.Literal (Cst.Integer s), r)
    | _ -> fail ?consumed:None ?message:None

  (* Factories *)

  let expect l = any >>= l
  let token e = any <?> function t, _ -> t = e
  let key s = token (Token.IDENT s)

  (* Identifier *)

  let ident = expect is_identifier

  (* Group, Literal and variable *)

  let group term = key "(" >+> term <+< key ")"
  let literal = expect is_string_or_int
  let variable = ident <&> fun (s, r) -> (Cst.Ident s, r)

  (* Operation *)

  let operations =
    token Token.INL
    <&> (fun r -> (Cst.BuildIn Cst.Inl, snd r))
    <|> (token Token.INR <&> fun r -> (Cst.BuildIn Cst.Inr, snd r))
    <|> (token Token.FST <&> fun r -> (Cst.BuildIn Cst.Fst, snd r))
    <|> (token Token.SND <&> fun r -> (Cst.BuildIn Cst.Snd, snd r))

  (* Functional *)

  (* (ident)+ '=>' term *)
  let abstraction term =
    ?!(rep ident <+< token Token.IMPLY)
    <+> term
    <&> fun (t, (e, r1)) ->
    let t = List.map fst t in
    let r0 = List.fold_right (fun _ r -> r) t r1 in
    (Cst.Abs (t, e), Region.Construct.combine r0 r1)

  (* term term *)
  let application term =
    term
    <&> fun (rhd, r1) (lhd, r0) ->
    (Cst.App (lhd, rhd), Region.Construct.combine r0 r1)

  (* 'let' ident = term 'in' term *)
  let let_binding term =
    token Token.LET
    >+> ident
    <+< token Token.EQUAL
    <+> term
    <+< token Token.IN
    <+> term
    <&> fun (((id, r0), (v, _)), (b, r1)) ->
    (Cst.Let (id, v, b), Region.Construct.combine r0 r1)

  (* Product *)

  (* term ',' term *)
  let product term =
    token Token.PRODUCT
    >+> term
    <&> fun (rhd, r1) (lhd, r0) ->
    (Cst.Pair (lhd, rhd), Region.Construct.combine r0 r1)

  (* case ident term term *)
  let case term =
    token Token.CASE
    >+> ident
    <+> term
    <+> term
    <&> fun (((id, r0), (left, _)), (right, r1)) ->
    (Cst.Case (id, left, right), Region.Construct.combine r0 r1)

  (* Main rules *)

  let simple_term term =
    fix (fun simple_term ->
        group term
        <|> operations
        <|> literal
        <|> variable
        <|> let_binding term
        <|> case simple_term
        <|> abstraction term )

  let term =
    fix (fun term ->
        simple_term term
        <+> (product term <|> application term <|> return id)
        <&> fun (e, f) -> f e )

  let declarations =
    opt_rep
      ( token Token.VAL
      >+> ident
      <+< token Token.EQUAL
      <+> term
      <&> fun ((id, _), e) -> (id, e) )
end

let analyse (type a)
    (module P : Ephel_parser_parsec.Specs.PARSEC
      with type Source.t = a
       and type Source.e = Token.with_location ) =
  let module M = Rules (P) in
  M.declarations
