type t =
  | INL
  | INR
  | CASE
  | VAL
  | LET
  | IN
  | FST
  | SND
  | INTEGER of int
  | STRING of string
  | IMPLY
  | EQUAL
  | PRODUCT
  | LPAR
  | RPAR
  | IDENT of string

type with_location = t * Ephel_parser_source.Region.t
