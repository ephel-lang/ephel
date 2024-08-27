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

let region = function
  | Ident (_, r)
  | Literal (_, r)
  | App (_, _, r)
  | Abs (_, _, r)
  | Let (_, _, _, r)
  | Builtin (_, _, r)
  | Pair (_, _, r)
  | Case (_, _, _, r) ->
    r
