open Ephel_parser_source

type builtin =
  | Inl
  | Inr
  | Fst
  | Snd

type literal =
  | Integer of int
  | String of string

type t =
  | Ident of string * Region.t
  | Literal of literal * Region.t
  | App of t * t * Region.t
  | Abs of string list * t * Region.t
  | Let of string * t * t * Region.t
  | Builtin of builtin * t * Region.t
  | Pair of t * t * Region.t
  | Case of string * t * t * Region.t

val region : t -> Region.t
