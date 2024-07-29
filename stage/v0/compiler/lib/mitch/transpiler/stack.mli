type t =
  | VAL of string
  | VAR of string

val fold : value:(string -> 'b) -> variable:(string -> 'b) -> t -> 'b
val render_stack : Format.formatter -> t list -> unit
