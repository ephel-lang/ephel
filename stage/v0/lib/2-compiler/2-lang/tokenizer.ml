module Tokens
    (Parsec : Ephel_parser_parsec.Specs.PARSEC with type Source.e = char) =
struct
  open Ephel_parser_parsec.Core (Parsec)
  open Ephel_parser_parsec.Literal (Parsec)
  open Ephel_parser_source.Utils
  open Preface_core.Fun
  open Token

  let to_ident (c, l) = IDENT (string_of_chars (c :: l))

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

  let _INL_ = string "inl" <&> const INL
  let _INR_ = string "inr" <&> const INR
  let _CASE_ = string "case" <&> const CASE
  let _VAL_ = string "val" <&> const VAL
  let _LET_ = string "let" <&> const LET
  let _IN_ = string "in" <&> const IN
  let _FST_ = string "fst" <&> const FST
  let _SND_ = string "snd" <&> const SND
  let _INTEGER_ = integer <&> fun s -> INTEGER s
  let _STRING_ = Delimited.string <&> fun s -> STRING s
  let _IMPLY_ = string "=>" <&> const IMPLY
  let _EQUAL_ = string "=" <&> const EQUAL
  let _PRODUCT_ = string "," <&> const PRODUCT
  let _LPAR_ = string "(" <&> const LPAR
  let _RPAR_ = string ")" <&> const RPAR
  let _IDENT_ = alpha <+> opt_rep (char '_' <|> digit <|> alpha) <&> to_ident

  let token =
    localized
      ( _INL_
      <|> _INR_
      <|> _CASE_
      <|> _VAL_
      <|> _LET_
      <|> _IN_
      <|> _FST_
      <|> _SND_
      <|> _INTEGER_
      <|> _STRING_
      <|> _IMPLY_
      <|> _EQUAL_
      <|> _PRODUCT_
      <|> _LPAR_
      <|> _RPAR_
      <|> _IDENT_ )
end
