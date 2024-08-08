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

  (* Production rules *)

  let group term = key "(" >+> term <+< key ")"
  let literal = expect string_or_int
  let ident = expect identifier

  let functional term =
    ?!(ident <+> opt_rep ident <+< token Token.IMPLY)
    <+> term
    <&> fun (((h, r0), t), (e, r1)) ->
    let t = List.map fst t in
    (Cst.Abs (h :: t, e), Region.Construct.combine r0 r1)

  (* Main production rule *)

  let term = fix (fun term -> group term <|> literal <|> functional term)
end

let analyse (type a)
    (module P : Ephel_parser_parsec.Specs.PARSEC
      with type Source.t = a
       and type Source.e = Token.with_location ) =
  let module M = Rules (P) in
  M.term
