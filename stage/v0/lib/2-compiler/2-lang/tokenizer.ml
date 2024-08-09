module Tokens
    (Parsec : Ephel_parser_parsec.Specs.PARSEC with type Source.e = char) =
struct
  open Ephel_parser_parsec.Core (Parsec)
  open Ephel_parser_parsec.Literal (Parsec)
  open Ephel_parser_source.Utils
  open Preface_core.Fun
  open Token

  let to_token s =
    match s with
    | "inl" -> INL
    | "inr" -> INR
    | "case" -> CASE
    | "val" -> VAL
    | "let" -> LET
    | "in" -> IN
    | "fst" -> FST
    | "snd" -> SND
    | s -> STRING s

  let localized p s =
    let open Ephel_parser_parsec.Response.Destruct in
    let open Ephel_parser_parsec.Response.Construct in
    let open Ephel_parser_source.Region.Construct in
    let start = Parsec.Source.Access.location s in
    fold
      ~success:(fun (a, b, s) ->
        let finish = Parsec.Source.Access.location s in
        success ((a, create start finish), b, s) )
      ~failure:(fun (a, b, s) -> failure (a, b, s))
      (p s)

  (* skipped characters *)

  let spaces = char_in_string " \t\n\r"

  let operator =
    rep (char_in_string "^$+-*/%~@#&!-_?.:*¨°><=[]{}\\|")
    <&> fun l -> string_of_chars l

  let alpha_num =
    alpha
    <+> opt_rep (char_in_string "_-" <|> digit <|> alpha)
    <&> fun (c, l) -> string_of_chars (c :: l)

  (* tokens *)

  let _INTEGER_ = integer <&> fun s -> INTEGER s
  let _STRING_ = Delimited.string <&> fun s -> STRING s
  let _IMPLY_ = string "=>" <&> const IMPLY
  let _EQUAL_ = string "=" <&> const EQUAL
  let _PRODUCT_ = string "," <&> const PRODUCT
  let _LPAR_ = string "(" <&> const LPAR
  let _RPAR_ = string ")" <&> const RPAR
  let _OPERATOR_ = operator <&> fun s -> IDENT s
  let _IDENT_ = alpha_num <&> to_token

  (* Main entry *)

  let token =
    spaces
    >+> localized
          ( _INTEGER_
          <|> _STRING_
          <|> _IMPLY_
          <|> _EQUAL_
          <|> _PRODUCT_
          <|> _LPAR_
          <|> _RPAR_
          <|> _OPERATOR_
          <|> _IDENT_ )
    <+< spaces
end

let tokenize (type a)
    (module P : Ephel_parser_parsec.Specs.PARSEC
      with type Source.t = a
       and type Source.e = char ) =
  let module M = Tokens (P) in
  M.token
