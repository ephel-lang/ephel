type operation =
  | Inl
  | Inr
  | Fst
  | Snd

type literal =
  | Integer of int
  | String of string

type t =
  | Ident of string
  | Literal of literal
  | App of t list
  | Abs of string list * t
  | Let of string * t * t
  | BuildIn of operation
  | Pair of t * t
  | Case of string * t * t

type with_location = t * Ephel_parser_source.Region.t
