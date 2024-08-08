(* Rules *)

open Ephel_parser_parsec

module Rules (Parsec : Specs.PARSEC with type Source.e = Token.with_location) =
struct
  open Ephel_parser_parsec.Core (Parsec)

  let _ident = function
    | Token.IDENT s, r -> return (s, r)
    | _ -> fail ?consumed:None ?message:None

  let literal = function
    | Token.STRING s, r -> return (Cst.Literal (Cst.String s, r))
    | Token.INTEGER s, r -> return (Cst.Literal (Cst.Integer s, r))
    | _ -> fail ?consumed:None ?message:None

  let expect l = any >>= l
  let token e = any <?> function t, _ -> t = e
  let key s = token (Token.IDENT s)
  let group term = key "(" >+> term <+< key ")"
  let term = fix (fun term -> group term <|> expect literal)
end

let analyse (type a)
    (module P : Ephel_parser_parsec.Specs.PARSEC
      with type Source.e = Token.with_location
       and type Source.t = a ) =
  let module M = Rules (P) in
  M.term
