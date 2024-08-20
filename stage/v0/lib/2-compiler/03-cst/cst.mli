type operation =
  | Inl
  | Inr
  | Fst
  | Snd

type literal =
  | Integer of int
  | String of string

type t =
  | Ident of string * Ephel_parser_source.Region.t
  | Literal of literal * Ephel_parser_source.Region.t
  | App of t * t * Ephel_parser_source.Region.t
  | Abs of string list * t * Ephel_parser_source.Region.t
  | Let of string * t * t * Ephel_parser_source.Region.t
  | BuildIn of operation * Ephel_parser_source.Region.t
  | Pair of t * t * Ephel_parser_source.Region.t
  | Case of string * t * t * Ephel_parser_source.Region.t

val region : t -> Ephel_parser_source.Region.t
