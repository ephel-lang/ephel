open Ephel_parser_source

type t =
  | INL
  | INR
  | CASE
  | VAL
  | LET
  | IN
  | FST
  | SND
  | INT of int
  | STRING of string
  | IMPLY
  | EQUAL
  | PRODUCT
  | LPAR
  | RPAR
  | IDENT of string

type with_location = t * Region.t
