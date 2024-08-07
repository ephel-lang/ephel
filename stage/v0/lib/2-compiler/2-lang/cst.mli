open Ephel_parser_source

type operation =
  | Inl
  | Inr
  | Fst
  | Snd

type literal =
  | Integer of int
  | String of string

type term =
  | Ident of string * Region.t
  | Literal of literal * Region.t
  | App of term list * Region.t
  | Abs of string * term * Region.t
  | Let of string list * term * term * Region.t
  | BuildIn of operation * Region.t
  | Pair of term * term * Region.t
  | Case of string * term * term * Region.t
