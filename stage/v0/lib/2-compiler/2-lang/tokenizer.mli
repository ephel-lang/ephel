module Tokens
    (Parsec : Ephel_parser_parsec.Specs.PARSEC with type Source.e = char) : sig
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

  val _VAL_ : t Parsec.t
  val _EQUAL_ : t Parsec.t
  val _STRING_ : t Parsec.t
  val _IDENT_ : t Parsec.t
  val _IMPLY_ : t Parsec.t
  val _LET_ : t Parsec.t
  val _IN_ : t Parsec.t
  val _PRODUCT_ : t Parsec.t
  val _FST_ : t Parsec.t
  val _SND_ : t Parsec.t
  val _CASE_ : t Parsec.t
  val _INL_ : t Parsec.t
  val _INR_ : t Parsec.t
end
