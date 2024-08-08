(* Rules *)

open Ephel_parser_source
open Ephel_parser_parsec

module Rules (Parsec : Specs.PARSEC with type Source.e = Token.with_location) =
struct
  open Ephel_parser_parsec.Core (Parsec)

  (* Basic matchers *)

  let identifier = function
    | Token.IDENT s, r -> return (s, r)
    | _ -> fail ?consumed:None ?message:None

  let string_or_int = function
    | Token.STRING s, r -> return (Cst.Literal (Cst.String s), r)
    | Token.INTEGER s, r -> return (Cst.Literal (Cst.Integer s), r)
    | _ -> fail ?consumed:None ?message:None

  (* Factories *)

  let expect l = any >>= l
  let token e = any <?> function t, _ -> t = e
  let key s = token (Token.IDENT s)

  (* Identifier *)

  let ident = expect identifier

  (* Group, Literal and variable *)

  let group term = key "(" >+> term <+< key ")"
  let literal = expect string_or_int
  let variable = ident <&> fun (s, r) -> (Cst.Ident s, r)

  (* Operation *)

  let operations =
    token Token.INL
    <&> (fun r -> (Cst.BuildIn Cst.Inl, snd r))
    <|> (token Token.INR <&> fun r -> (Cst.BuildIn Cst.Inr, snd r))
    <|> (token Token.FST <&> fun r -> (Cst.BuildIn Cst.Fst, snd r))
    <|> (token Token.SND <&> fun r -> (Cst.BuildIn Cst.Snd, snd r))

  (* Functional *)

  let abstraction term =
    (* (ident)+ '=>' term *)
    ?!(ident <+> opt_rep ident <+< token Token.IMPLY)
    <+> term
    <&> fun (((h, r0), t), (e, r1)) ->
    let t = List.map fst t in
    (Cst.Abs (h :: t, e), Region.Construct.combine r0 r1)

  let application term =
    (* term term+ *)
    ?!(term <+> term)
    <+> opt_rep term
    <&> fun (((h, r0), (g, r1)), t) ->
    let r1 = List.fold_left (fun _ (_, r) -> r) r1 t in
    let t = List.map fst t in
    (Cst.App (h :: g :: t), Region.Construct.combine r0 r1)

  let let_binding term =
    (* 'let' ident = term 'in' term *)
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
    ?!(term <+< token Token.PRODUCT)
    <+> term
    <&> fun ((lhd, r0), (rhd, r1)) ->
    (Cst.Pair (lhd, rhd), Region.Construct.combine r0 r1)

  (* case ident term term *)
  let case term =
    token Token.CASE
    >+> ident
    <+> term
    <+> term
    <&> fun (((id, r0), (left, _)), (right, r1)) ->
    (Cst.Case (id, left, right), Region.Construct.combine r0 r1)

  (* Main rule *)

  let simple_term term =
    fix (fun simple_term ->
        group term
        <|> operations
        <|> literal
        <|> variable
        <|> let_binding term
        <|> case simple_term )

  let term =
    fix (fun term ->
        simple_term term
        <|> abstraction term
        <|> product (simple_term term)
        <|> application (simple_term term) )
end

let analyse (type a)
    (module P : Ephel_parser_parsec.Specs.PARSEC
      with type Source.t = a
       and type Source.e = Token.with_location ) =
  let module M = Rules (P) in
  M.term
