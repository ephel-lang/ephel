module Tokens
    (Parsec : Ephel_parser_parsec.Specs.PARSEC with type Source.e = char) =
struct
  open Ephel_parser_parsec.Core (Parsec)
  open Ephel_parser_parsec.Literal (Parsec)
  open Ephel_parser_source.Utils
  open Preface_core.Fun

  type t =
    | VAL
    | EQUAL
    | STRING of string
    | IDENT of string
    | IMPLY
    | LET
    | IN
    | PRODUCT
    | FST
    | SND
    | CASE
    | INL
    | INR

  let to_ident (c, l) = IDENT (string_of_chars (c :: l))
  let _VAL_ = string "val" <&> const VAL
  let _EQUAL_ = string "=" <&> const EQUAL
  let _STRING_ = Delimited.string <&> fun s -> STRING s
  let _IDENT_ = alpha <+> opt_rep (char '_' <|> digit <|> alpha) <&> to_ident
  let _IMPLY_ = string "=>" <&> const IMPLY
  let _LET_ = string "let" <&> const LET
  let _IN_ = string "in" <&> const IN
  let _PRODUCT_ = string "," <&> const PRODUCT
  let _FST_ = string "fst" <&> const FST
  let _SND_ = string "snd" <&> const SND
  let _CASE_ = string "case" <&> const CASE
  let _INL_ = string "inl" <&> const INL
  let _INR_ = string "inr" <&> const INR
end
